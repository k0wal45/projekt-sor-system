package controllers

import (
	"esor-backend/config"
	"esor-backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// TriageInput reprezentuje zaktualizowaną strukturę danych wejściowych z Fluttera
type TriageInput struct {
	PatientID      uint                `json:"id_pacjenta" binding:"required"`
	ArrivalMode    models.ArrivalMode  `json:"forma_przybycia" binding:"required"`
	Injury         bool                `json:"injury"` // bool nie może mieć binding:"required", bo false wywali walidację
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

// POST /api/admissions/predict-ktas
// Wstępna ocena stanu pacjenta przez algorytm / model AI
func PredictKtas(c *gin.Context) {
	var input TriageInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Błąd walidacji danych wejściowych do Triage"})
		return
	}

	// Heurystyka ratunkowa (mock przed spięciem HTTP z kontenerem AI w Pythonie)
	suggestedKtas := 3 // Domyślnie kod żółty (pilny)

	if input.MentalStatus == models.MentalNieprzytomny || input.HR > 130 || input.SBP < 90 {
		suggestedKtas = 1 // Kod czerwony (krytyczny, natychmiastowa reanimacja)
	} else if input.PainLvl >= 8 || input.SBP > 180 {
		suggestedKtas = 2 // Kod pomarańczowy (bardzo pilny)
	}

	c.JSON(http.StatusOK, gin.H{
		"suggested_priority_ktas": suggestedKtas,
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
		PatientID:         input.PatientID,
		TriageStaffID:     triageStaffID.(uint),
		ArrivalMode:       input.ArrivalMode,
		Injury:            input.Injury,
		MentalStatus:      input.MentalStatus,
		Pain:              input.Pain,
		PainLvl:           input.PainLvl,
		HR:                input.HR,
		SBP:               input.SBP,
		DBP:               input.DBP,
		RR:                input.RR,
		BT:                input.BT,
		ChiefComplaint:    input.ChiefComplaint,
		PriorityKtas:      input.PriorityKtas,
		IsAiPredicted:     input.IsAiPredicted,
		StatusAdmission:   models.StatusWPoczekalni, // Pacjent ląduje w kolejce oczekujących
	}

	if err := config.DB.Create(&newAdmission).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd zapisu karty przyjęcia do bazy danych"})
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
// Sortowanie: Od najwyższego priorytetu KTAS (1 -> 5), a w obrębie tego samego kodu według czasu zapisu (FIFO)
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
		"W_POCZEKALNI":        true,
		"W_GABINECIE":         true,
		"OCZEKUJE_NA_WYNIKI": true,
		"ZAKONCZONE":          true,
	}

	if !validStatuses[input.Status] {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Nieprawidłowa wartość statusu przyjęcia"})
		return
	}

	// Aktualizacja w bazie danych
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
		"status":  admission.StatusAdmission,
	})
}