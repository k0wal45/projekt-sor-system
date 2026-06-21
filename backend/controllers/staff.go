package controllers

import (
	"esor-backend/config"
	"esor-backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GET /api/staff
// Pobieranie katalogu pracowników z filtrowaniem (q = imię/nazwisko, role = rola)
func GetStaffList(c *gin.Context) {
	searchQuery := c.Query("q")
	roleFilter := c.Query("role")

	var staff []models.Staff
	dbQuery := config.DB.Model(&models.Staff{})

	// Filtrowanie po roli (jeśli podano)
	if roleFilter != "" {
		dbQuery = dbQuery.Where("role = ?", roleFilter)
	}

	// Wyszukiwanie po imieniu LUB nazwisku (case-insensitive dzięki ILIKE w Postgres)
	if searchQuery != "" {
		likePattern := "%" + searchQuery + "%"
		dbQuery = dbQuery.Where("first_name ILIKE ? OR last_name ILIKE ?", likePattern, likePattern)
	}

	// Wycinamy hasła z odpowiedzi ze względów bezpieczeństwa
	if err := dbQuery.Select("id", "login_email", "first_name", "last_name", "role", "created_at").Find(&staff).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Błąd pobierania listy personelu"})
		return
	}

	c.JSON(http.StatusOK, staff)
}