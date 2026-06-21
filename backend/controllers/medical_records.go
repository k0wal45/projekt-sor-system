package controllers

import (
	"esor-backend/config"
	"esor-backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// POST /api/consultations
// Zapisanie wywiadu, diagnozy i decyzji końcowej
func CreateConsultation(c *gin.Context) {
	doctorID, _ := c.Get("userID")

	var input struct {
		AdmissionID       uint   `json:"id_przyjecia" binding:"required"`
		Notes             string `json:"wywiad_lekarski" binding:"required"`
		Diagnosis         string `json:"rozpoznanie_icd10" binding:"required"`
		DischargeDecision string `json:"decyzja_wyjsciowa" binding:"required"` // DO_DOMU, HOSPITALIZACJA, ZGON
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Nieprawidłowe dane formularza"})
		return
	}

	consultation := models.Consultation{
		AdmissionID:       input.AdmissionID,
		DoctorID:          doctorID.(uint),
		Notes:             input.Notes,
		Diagnosis:         input.Diagnosis,
		DischargeDecision: input.DischargeDecision,
	}

	// Zapis konsultacji i jednoczesna aktualizacja statusu pacjenta na ZAKONCZONE
	tx := config.DB.Begin()
	
	if err := tx.Create(&consultation).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd zapisu konsultacji"})
		return
	}

	if err := tx.Model(&models.Admission{}).Where("id = ?", input.AdmissionID).Update("status_przyjecia", "ZAKONCZONE").Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd podczas zamykania karty przyjęcia"})
		return
	}

	tx.Commit()

	// Na wszelki wypadek puszczamy broadcast WS, gdyby system monitorował też globalny stan oddziału
	go BroadcastQueue()

	c.JSON(http.StatusCreated, gin.H{
		"message": "Konsultacja zapisana, karta pacjenta została pomyślnie zamknięta",
		"id":      consultation.ID,
	})
}

// POST /api/diagnostic-orders
// Zlecenie dodatkowego badania (RTG, Krew itp.)
func CreateDiagnosticOrder(c *gin.Context) {
	doctorID, _ := c.Get("userID")

	var input struct {
		AdmissionID uint   `json:"id_przyjecia" binding:"required"`
		TestType    string `json:"typ_badania" binding:"required"` // KREW, RTG, EKG
		Description string `json:"opis_zlecenia"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Niepoprawne dane zlecenia"})
		return
	}

	order := models.DiagnosticOrder{
		AdmissionID: input.AdmissionID,
		DoctorID:    doctorID.(uint),
		TestType:    input.TestType,
		Description: input.Description,
		Status:      "ZLECONE",
	}

	tx := config.DB.Begin()

	if err := tx.Create(&order).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd zapisu zlecenia diagnostycznego"})
		return
	}

	// Zmieniamy status pacjenta na OCZEKUJE_NA_WYNIKI
	if err := tx.Model(&models.Admission{}).Where("id = ?", input.AdmissionID).Update("status_przyjecia", "OCZEKUJE_NA_WYNIKI").Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd aktualizacji statusu przyjęcia"})
		return
	}

	tx.Commit()
	go BroadcastQueue()

	c.JSON(http.StatusCreated, gin.H{
		"message": "Badanie zostało pomyślnie zlecone",
		"id":      order.ID,
		"status":  "OCZEKUJE_NA_WYNIKI",
	})
}