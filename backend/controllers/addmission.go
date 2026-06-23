package controllers

import (
	"bytes"
	"encoding/json"
	"esor-backend/config"
	"esor-backend/models"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// TriageInput reprezentuje strukturę danych wejściowych z Fluttera do zapisu karty przyjęcia
type TriageInput struct {
	PatientID      uint                `json:"id_pacjenta" binding:"required"`
	ArrivalMode    models.ArrivalMode  `json:"forma_przybycia" binding:"required"`
	Injury         bool                `json:"injury"`
	MentalStatus   models.MentalStatus `json:"mental_status" binding:"required"`
	Pain           bool                `json:"pain"`
	PainLvl        int                 `json:"pain_lvl" binding:"min=0,max=10"`
	HR             int                 `json:"hr" binding:"required"`
	SBP            int                 `json:"sbp" binding:"required"`
	DBP            int                 `json:"dbp" binding:"required"`
	RR             int                 `json:"rr" binding:"required"`
	BT             float64             `json:"bt" binding:"required"`
	ChiefComplaint string              `json:"chief_complaint" binding:"required"`
	PriorityKtas   int                 `json:"priority_ktas" binding:"required,min=1,max=5"`
	IsAiPredicted  bool                `json:"is_ai_predicted"`
}

// Funkcja pomocnicza obliczająca wiek na podstawie daty urodzenia
func calculateAge(birthDate time.Time) int {
	now := time.Now()
	years := now.Year() - birthDate.Year()
	if now.YearDay() < birthDate.YearDay() {
		years--
	}
	if years < 0 {
		return 0
	}
	return years
}

// POST /api/admissions/predict-ktas
// Wstępna ocena stanu pacjenta przez algorytm / model AI (Spięta z kontenerem sor_ai)
func PredictKtas(c *gin.Context) {
	// Struktura lokalna bez pola priority_ktas, zapobiegająca błędom walidacji braku priorytetu
	var input struct {
		PatientID      uint                `json:"id_pacjenta" binding:"required"`
		ArrivalMode    models.ArrivalMode  `json:"forma_przybycia" binding:"required"`
		Injury         bool                `json:"injury"`
		MentalStatus   models.MentalStatus `json:"mental_status" binding:"required"`
		Pain           bool                `json:"pain"`
		PainLvl        int                 `json:"pain_lvl" binding:"min=0,max=10"`
		HR             int                 `json:"hr" binding:"required"`
		SBP            int                 `json:"sbp" binding:"required"`
		DBP            int                 `json:"dbp" binding:"required"`
		RR             int                 `json:"rr" binding:"required"`
		BT             float64             `json:"bt" binding:"required"`
		ChiefComplaint string              `json:"chief_complaint" binding:"required"`
		IsAiPredicted  bool                `json:"is_ai_predicted"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Błąd walidacji danych wejściowych do Triage"})
		return
	}

	// 1. Pobranie danych pacjenta z bazy w celu wyliczenia wieku (wymaganego przez model AI)
	var patient models.Patient
	if err := config.DB.First(&patient, input.PatientID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nie znaleziono pacjenta o podanym ID"})
		return
	}
	age := calculateAge(patient.DateOfBirth)

	// 2. Przygotowanie payloadu dla mikrousługi FastAPI (TriageRequest)
	aiPayload := map[string]int{
		"age":      age,
		"hr":       input.HR,
		"sbp":      input.SBP,
		"dbp":      input.DBP,
		"pain_lvl": input.PainLvl,
	}

	jsonPayload, err := json.Marshal(aiPayload)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd przetwarzania danych dla modułu AI"})
		return
	}

	// 3. Wywołanie zewnętrznego endpointu kontenera AI po sieci mostkowej systemu Docker
	aiServiceURL := "http://ai:8000/api/triage" // Port wewnątrz sieci to 8000 (zgodnie z definicją uvicorn/fastapi)
	
	resp, err := http.Post(aiServiceURL, "application/json", bytes.NewBuffer(jsonPayload))
	if err != nil {
		c.JSON(http.StatusServiceUnavailable, gin.H{"error": "Mikrousługa analityczna AI jest obecnie nieosiągalna"})
		return
	}
	defer resp.Body.Close()

	// Obsługa błędów zwróconych przez FastAPI (np. 503 gdy brak pliku pickle lub 500)
	if resp.StatusCode != http.StatusOK {
		var aiError map[string]interface{}
		json.NewDecoder(resp.Body).Decode(&aiError)
		c.JSON(resp.StatusCode, gin.H{"error": fmt.Sprintf("Błąd modułu AI: %v", aiError["detail"])})
		return
	}

	// 4. Dekodowanie odpowiedzi z modelu (TriageResponse)
	var aiResponse struct {
		PriorityLevel int `json:"priority_level"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&aiResponse); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Niepoprawny format odpowiedzi z serwera AI"})
		return
	}

	// 5. Zwrócenie danych wyjściowych w dokładnie niezmienionym formacie (zgodnym z Twoim dotychczasowym API)
	c.JSON(http.StatusOK, gin.H{
		"suggested_priority_ktas": aiResponse.PriorityLevel,
		"is_ai_predicted":         true,
	})
}

// POST /api/admissions
// Ostateczny zapis karty Triage i wrzucenie pacjenta do poczekalni SOR
func CreateAdmission(c *gin.Context) {
	var input TriageInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Niepoprawne dane formularza: " + err.Error()})
		return
	}

	// Pobranie ID zalogowanego personelu (Ratownika/Pielęgniarki) z kontekstu JWT
	triageStaffID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd autoryzacji: Brak ID pracownika w sesji"})
		return
	}

	// Budowanie modelu bazy danych
	newAdmission := models.Admission{
		PatientID:       input.PatientID,
		TriageStaffID:   triageStaffID.(uint),
		ArrivalMode:     input.ArrivalMode,
		Injury:          input.Injury,
		MentalStatus:    input.MentalStatus,
		Pain:            input.Pain,
		PainLvl:         input.PainLvl,
		HR:              input.HR,
		SBP:             input.SBP,
		DBP:             input.DBP,
		RR:              input.RR,
		BT:              input.BT,
		ChiefComplaint:  input.ChiefComplaint,
		PriorityKtas:    input.PriorityKtas,
		IsAiPredicted:   input.IsAiPredicted,
		StatusAdmission: models.StatusWPoczekalni, // Pacjent ląduje w kolejce oczekujących
	}

	// Omit wycina próby automatycznego mapowania asocjacji przez GORM, co blokuje powstawanie błędnych kolumn
	if err := config.DB.Omit("Patient", "TriageStaff", "AttendingDoctor").Create(&newAdmission).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd zapisu karty przyjęcia do bazy danych: " + err.Error()})
		return
	}

	go BroadcastQueue()

	c.JSON(http.StatusCreated, gin.H{
		"message":   "Pacjent zarejestrowany na oddziale i dodany do kolejki",
		"admission": newAdmission,
	})
}

// GET /api/admissions/queue
// Pobranie pacjentów oczekujących w poczekalni (Kolejka Główna)
func GetQueue(c *gin.Context) {
	var queue []models.Admission

	err := config.DB.Where("status_przyjecia = ?", models.StatusWPoczekalni).
		Order("priority_ktas ASC, data_przyjecia ASC").
		Find(&queue).Error

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd ładowania kolejki SOR"})
		return
	}

	c.JSON(http.StatusOK, queue)
}

// GET /api/admissions
// Pobranie całego archiwum i historii przyjęć z opcją filtrowania
func GetAdmissions(c *gin.Context) {
	var admissions []models.Admission
	
	status := c.Query("status_przyjecia")
	ktas := c.Query("priority_ktas")

	query := config.DB.Model(&models.Admission{})

	if status != "" {
		query = query.Where("status_przyjecia = ?", status)
	}
	if ktas != "" {
		query = query.Where("priority_ktas = ?", ktas)
	}

	if err := query.Order("data_przyjecia DESC").Find(&admissions).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd pobierania archiwum"})
		return
	}

	c.JSON(http.StatusOK, admissions)
}

// GET /api/admissions/:id
// Pobranie szczegółowych informacji o pojedynczym przyjęciu
func GetAdmissionByID(c *gin.Context) {
	id := c.Param("id")
	var admission models.Admission

	if err := config.DB.First(&admission, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Karta przyjęcia o podanym ID nie istnieje"})
		return
	}

	c.JSON(http.StatusOK, admission)
}

// GET /api/patients/:id/admissions
// Pobranie całej historii pobytów na SOR konkretnego pacjenta
func GetPatientAdmissions(c *gin.Context) {
	patientID := c.Param("id")
	var history []models.Admission

	err := config.DB.Where("id_pacjenta = ?", patientID).
		Order("data_przyjecia DESC").
		Find(&history).Error

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd ładowania kartoteki historycznej pacjenta"})
		return
	}

	c.JSON(http.StatusOK, history)
}

// DELETE /api/admissions/:id
// Anulowanie zgłoszenia / usunięcie karty z kolejki
func CancelAdmission(c *gin.Context) {
	id := c.Param("id")
	var admission models.Admission

	if err := config.DB.First(&admission, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nie znaleziono dokumentu przyjęcia"})
		return
	}

	if err := config.DB.Delete(&admission).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Nie udało się anulować przyjęcia"})
		return
	}

	go BroadcastQueue()
	c.JSON(http.StatusOK, gin.H{"message": "Karta przyjęcia została usunięta z systemu"})
}

// PATCH /api/admissions/:id/status
func UpdateAdmissionStatus(c *gin.Context) {
	id := c.Param("id")

	var input struct {
		Status string `json:"status_przyjecia" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Niepoprawny format żądania"})
		return
	}

	validStatuses := map[string]bool{
		"W_POCZEKALNI":       true,
		"W_GABINECIE":        true,
		"OCZEKUJE_NA_WYNIKI": true,
		"ZAKONCZONE":          true,
	}

	if !validStatuses[input.Status] {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Nieprawidłowa wartość statusu przyjęcia"})
		return
	}

	var admission models.Admission
	if err := config.DB.First(&admission, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nie znaleziono karty przyjęcia o podanym ID"})
		return
	}

	if err := config.DB.Model(&admission).Update("status_przyjecia", input.Status).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd podczas aktualizacji statusu w bazie danych"})
		return
	}

	go BroadcastQueue()

	c.JSON(http.StatusOK, gin.H{
		"message": "Status przyjęcia został pomyślnie zaktualizowany",
		"status":  input.Status,
	})
}

// Struktura DTO (Data Transfer Object) łącząca ID przyjęcia z pełnymi danymi pacjenta
type AdmissionArchiveDTO struct {
	AdmissionID     uint           `json:"id_przyjecia"`
	PriorityKtas    int            `json:"priority_ktas"`
	StatusAdmission string         `json:"status_przyjecia"`
	AdmissionTime   time.Time      `json:"data_przyjecia"`
	Patient         models.Patient `json:"pacjent"` // Pełny model pacjenta wewnątrz przyjęcia
}

// GET /api/admissions/history
// Pobieranie archiwum wszystkich przyjęć wraz z pełnymi danymi pacjentów
func GetAdmissionsHistory(c *gin.Context) {
	var admissions []models.Admission

	// Inicjalizujemy bazowe zapytanie GORM i automatycznie ładujemy (Preload) relację Patient
	query := config.DB.Preload("Patient")

	// Obsługa filtrów z Query Params (jeśli frontend przesyła filtry) [cite: 487]
	if status := c.Query("status_przyjecia"); status != "" {
		query = query.Where("status_przyjecia = ?", status)
	}
	if ktas := c.Query("priority_ktas"); ktas != "" {
		query = query.Where("priority_ktas = ?", ktas)
	}

	// Pobieramy dane posortowane od najnowszych przyjęć
	if err := query.Order("data_przyjecia DESC").Find(&admissions).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd podczas pobierania archiwum przyjęć"})
		return
	}

	// Mapujemy pobrane rekordy na strukturę oczekiwaną przez frontend
	var response []AdmissionArchiveDTO
	for _, adm := range admissions {
		response = append(response, AdmissionArchiveDTO{
			AdmissionID:     adm.ID,
			PriorityKtas:    adm.PriorityKtas,
			StatusAdmission: string(adm.StatusAdmission),
			AdmissionTime:   adm.AdmissionTime,
			Patient:         adm.Patient, // Zawiera imię, nazwisko, PESEL itp.
		})
	}

	c.JSON(http.StatusOK, response)
}