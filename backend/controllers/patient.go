package controllers

import (
	"esor-backend/config"
	"esor-backend/models"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

// PatientInput definiuje strukturę JSON dopasowaną dokładnie do Twojego modelu
type PatientInput struct {
	Pesel                 string            `json:"pesel" binding:"required,len=11"`
	FirstName             string            `json:"first_name" binding:"required"`
	LastName              string            `json:"last_name" binding:"required"`
	DateOfBirth           string            `json:"date_of_birth" binding:"required"` // Format: YYYY-MM-DD
	Gender                models.Gender     `json:"gender" binding:"required"`       // M, K, INNY
	Address               string            `json:"address" binding:"required"`
	Phone                 string            `json:"phone" binding:"required"`
	Email                 string            `json:"email"`
	EmergencyContactName  string            `json:"emergency_contact_name" binding:"required"`
	EmergencyContactPhone string            `json:"emergency_contact_phone" binding:"required"`
	BloodGroup            models.BloodGroup `json:"blood_group"` // np. A+, 0-
	Allergies             string            `json:"allergies"`
	ChronicDiseases       string            `json:"chronic_diseases"`
}

// POST /api/patients
// Rejestracja nowego pacjenta na SOR
func CreatePatient(c *gin.Context) {
	var input PatientInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Błąd walidacji danych. Upewnij się, że PESEL ma 11 znaków oraz podałeś wymagane pola."})
		return
	}

	// Parsowanie daty urodzenia z formatu YYYY-MM-DD
	parsedDate, err := time.Parse("2006-01-02", input.DateOfBirth)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Niepoprawny format date_of_birth. Użyj YYYY-MM-DD"})
		return
	}

	// Przepisanie danych na strukturę modelu GORM
	newPatient := models.Patient{
		Pesel:                 input.Pesel,
		FirstName:             input.FirstName,
		LastName:              input.LastName,
		DateOfBirth:           parsedDate,
		Gender:                input.Gender,
		Address:               input.Address,
		Phone:                 input.Phone,
		Email:                 input.Email,
		EmergencyContactName:  input.EmergencyContactName,
		EmergencyContactPhone: input.EmergencyContactPhone,
		BloodGroup:            input.BloodGroup,
		Allergies:             input.Allergies,
		ChronicDiseases:       input.ChronicDiseases,
	}

	// Zapis do bazy danych PostgreSQL przez GORM
	if err := config.DB.Create(&newPatient).Error; err != nil {
		c.JSON(http.StatusConflict, gin.H{"error": "Pacjent o podanym numerze PESEL już istnieje w systemie"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Karta pacjenta została pomyślnie utworzona", "patient": newPatient})
}

// GET /api/patients/:pesel
// Szybkie wyszukiwanie pacjenta w bazie danych po numerze PESEL
func GetPatientByPesel(c *gin.Context) {
	pesel := c.Param("pesel")

	if len(pesel) != 11 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Niepoprawny numer PESEL (wymagane 11 cyfr)"})
		return
	}

	var patient models.Patient
	if err := config.DB.Where("pesel = ?", pesel).First(&patient).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nie znaleziono pacjenta o podanym numerze PESEL"})
		return
	}

	c.JSON(http.StatusOK, patient)
}

// GET /api/patients
// Zaawansowane pobieranie listy pacjentów z filtrami
func GetPatients(c *gin.Context) {
	firstName := c.Query("first_name")
	lastName := c.Query("last_name")
	gender := c.Query("gender")
	bloodGroup := c.Query("blood_group")
	
	// Filtry wiekowe (np. ?older_than=60 lub ?younger_than=18)
	olderThan := c.Query("older_than")
	youngerThan := c.Query("younger_than")
	
	// Filtr czasu rejestracji (np. ?registered_since=2026-06-15)
	registeredSince := c.Query("registered_since")

	var patients []models.Patient
	query := config.DB.Model(&models.Patient{})

	// 1. Filtrowanie tekstowe (ILIKE - ignoruje wielkość liter)
	if firstName != "" {
		query = query.Where("first_name ILIKE ?", "%"+firstName+"%")
	}
	if lastName != "" {
		query = query.Where("last_name ILIKE ?", "%"+lastName+"%")
	}

	// 2. Filtrowanie dokładne (ENUM-y)
	if gender != "" {
		query = query.Where("gender = ?", gender)
	}
	if bloodGroup != "" {
		query = query.Where("blood_group = ?", bloodGroup)
	}

	// 3. Logika filtrowania po wieku (starszy niż / młodszy niż)
	now := time.Now()
	if olderThan != "" {
		if age, err := strconv.Atoi(olderThan); err == nil {
			// Jeśli pacjent ma być starszy niż X lat, jego data urodzenia musi być PRZED: teraz - X lat
			targetDate := now.AddDate(-age, 0, 0)
			query = query.Where("date_of_birth <= ?", targetDate)
		}
	}
	if youngerThan != "" {
		if age, err := strconv.Atoi(youngerThan); err == nil {
			// Jeśli pacjent ma być młodszy niż X lat, jego data urodzenia musi być PO: teraz - X lat
			targetDate := now.AddDate(-age, 0, 0)
			query = query.Where("date_of_birth >= ?", targetDate)
		}
	}

	// 4. Filtr czasu rejestracji w systemie (np. pacjenci z dzisiejszego dyżuru)
	if registeredSince != "" {
		if parsedSince, err := time.Parse("2006-01-02", registeredSince); err == nil {
			query = query.Where("created_at >= ?", parsedSince)
		}
	}

	// Wykonanie zapytania i sortowanie od najnowszych zgłoszeń
	if err := query.Order("created_at DESC").Find(&patients).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd podczas zaawansowanego filtrowania pacjentów"})
		return
	}

	c.JSON(http.StatusOK, patients)
}

// PUT /api/patients/:pesel
// Aktualizacja danych istniejącego pacjenta
func UpdatePatient(c *gin.Context) {
	pesel := c.Param("pesel")

	if len(pesel) != 11 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Niepoprawny numer PESEL (wymagane 11 cyfr)"})
		return
	}

	var patient models.Patient
	// Znajdź pacjenta w bazie
	if err := config.DB.Where("pesel = ?", pesel).First(&patient).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nie znaleziono pacjenta o podanym numerze PESEL"})
		return
	}

	// Struktura dla danych do aktualizacji (wszystkie pola opcjonalne w locie)
	var updateData map[string]interface{}
	if err := c.ShouldBindJSON(&updateData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Błąd dekodowania danych JSON"})
		return
	}

	// Blokada zmiany PESEL-u, jeśli ktoś przesłał go w body
	delete(updateData, "pesel")
	delete(updateData, "id")

	// Obsługa konwersji daty, jeśli została przesłana do zmiany
	if dob, exists := updateData["date_of_birth"]; exists {
		if dobStr, ok := dob.(string); ok {
			parsedDate, err := time.Parse("2006-01-02", dobStr)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": "Niepoprawny format date_of_birth. Użyj YYYY-MM-DD"})
				return
			}
			updateData["date_of_birth"] = parsedDate
		}
	}

	// Zapis zmian w bazie danych
	if err := config.DB.Model(&patient).Updates(updateData).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd podczas aktualizacji danych pacjenta"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Dane pacjenta zostały pomyślnie zaktualizowane", "patient": patient})
}

// DELETE /api/patients/:pesel
// Usunięcie karty pacjenta z systemu
func DeletePatient(c *gin.Context) {
	pesel := c.Param("pesel")

	if len(pesel) != 11 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Niepoprawny numer PESEL (wymagane 11 cyfr)"})
		return
	}

	var patient models.Patient
	if err := config.DB.Where("pesel = ?", pesel).First(&patient).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nie znaleziono pacjenta o podanym numerze PESEL"})
		return
	}

	// Fizyczne usunięcie rekordu z bazy danych
	if err := config.DB.Delete(&patient).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd podczas usuwania pacjenta z bazy danych"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Karta pacjenta została trwale usunięta z systemu"})
}