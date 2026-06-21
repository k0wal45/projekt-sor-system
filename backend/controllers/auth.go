package controllers

import (
	"esor-backend/config"
	"esor-backend/models"
	"esor-backend/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// RegisterInput definiuje strukturę JSON oczekiwaną przy rejestracji
type RegisterInput struct {
	FirstName     string      `json:"first_name" binding:"required"`
	LastName      string      `json:"last_name" binding:"required"`
	AcademicTitle string      `json:"academic_title"`
	Role          models.Role `json:"role" binding:"required"`
	LoginEmail    string      `json:"login_email" binding:"required,email"`
	Password      string      `json:"password" binding:"required,min=6"`
}

// LoginInput definiuje strukturę JSON oczekiwaną przy logowaniu
type LoginInput struct {
	LoginEmail string `json:"login_email" binding:"required,email"`
	Password   string `json:"password" binding:"required"`
}

// POST /api/auth/register
func RegisterStaff(c *gin.Context) {
	var input RegisterInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Niepoprawne dane: " + err.Error()})
		return
	}

	hashedPassword, err := utils.HashPassword(input.Password)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd przetwarzania hasła"})
		return
	}

	newStaff := models.Staff{
		FirstName:     input.FirstName,
		LastName:      input.LastName,
		AcademicTitle: input.AcademicTitle,
		Role:          input.Role,
		LoginEmail:    input.LoginEmail,
		PasswordHash:  hashedPassword,
	}

	if err := config.DB.Create(&newStaff).Error; err != nil {
		c.JSON(http.StatusConflict, gin.H{"error": "Użytkownik o tym adresie e-mail już istnieje"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Konto personelu zostało pomyślnie utworzone"})
}

// POST /api/auth/login
func LoginStaff(c *gin.Context) {
	var input LoginInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var staff models.Staff
	if err := config.DB.Where("login_email = ?", input.LoginEmail).First(&staff).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Nieprawidłowy e-mail lub hasło"})
		return
	}

	if !utils.CheckPasswordHash(input.Password, staff.PasswordHash) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Nieprawidłowy e-mail lub hasło"})
		return
	}

	token, err := utils.GenerateToken(staff.ID, string(staff.Role))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd generowania tokenu dostępu"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"token": token,
		"user": gin.H{
			"id":         staff.ID,
			"first_name": staff.FirstName,
			"last_name":  staff.LastName,
			"role":       staff.Role,
		},
	})
}

// GET /api/auth/me
func GetMe(c *gin.Context) {
	// Wyciągamy ID użytkownika z kontekstu (ustawione przez AuthMiddleware)
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Nieautoryzowany"})
		return
	}

	var staff models.Staff
	if err := config.DB.First(&staff, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nie znaleziono użytkownika"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"id":         staff.ID,
		"first_name": staff.FirstName,
		"last_name":  staff.LastName,
		"role":       staff.Role,
		"email":      staff.LoginEmail,
	})
}