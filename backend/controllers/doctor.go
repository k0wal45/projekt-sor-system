package controllers

import (
	"esor-backend/config"
	"esor-backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GET /api/doctor/admissions
// Pobiera pacjentów przypisanych do zalogowanego lekarza (aktywnych lub historię)
func GetDoctorAdmissions(c *gin.Context) {
	// ID lekarza wyciągamy bezpiecznie z kontekstu JWT (ustawione przez AuthMiddleware)
	doctorID, _ := c.Get("userID")
	
	// Sprawdzamy filtr query params: /api/doctor/admissions?history=true
	isHistory := c.Query("history") == "true"

	var admissions []models.Admission
	query := config.DB.Where("id_lekarza_prowadzacego = ?", doctorID)

	if isHistory {
		// Pobierz zamknięte zgłoszenia
		query = query.Where("status_przyjecia = ?", "ZAKONCZONE")
	} else {
		// Pobierz aktywne zgłoszenia w gabinecie lub na badaniach
		query = query.Where("status_przyjecia IN ?", []string{"W_GABINECIE", "OCZEKUJE_NA_WYNIKI"})
	}

	if err := query.Order("priority_ktas ASC, data_przyjecia ASC").Find(&admissions).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd pobierania zgłoszeń lekarza"})
		return
	}

	c.JSON(http.StatusOK, admissions)
}

// PUT /api/admissions/:id/assign
// Lekarz klika "Pobierz pacjenta" z kolejki poczekalni
func AssignPatientToDoctor(c *gin.Context) {
	admissionID := c.Param("id")
	doctorID, _ := c.Get("userID")

	var admission models.Admission
	if err := config.DB.First(&admission, admissionID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nie znaleziono karty przyjęcia"})
		return
	}

	// Walidacja: czy pacjent na pewno jest w poczekalni
	if admission.StatusAdmission != "W_POCZEKALNI" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Nie można przejąć pacjenta, który nie znajduje się w poczekalni"})
		return
	}

	// Aktualizacja: przypisanie lekarza i zmiana statusu
	updates := map[string]interface{}{
		"id_lekarza_prowadzacego": doctorID,
		"status_przyjecia":        "W_GABINECIE",
	}

	if err := config.DB.Model(&admission).Updates(updates).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd podczas przypisywania lekarza"})
		return
	}

	go BroadcastQueue()

	c.JSON(http.StatusOK, gin.H{
		"message": "Pacjent został pomyślnie przyjęty do gabinetu",
		"status":  "W_GABINECIE",
	})
}