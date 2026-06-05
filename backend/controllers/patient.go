package controllers

import (
	"esor-backend/config"
	"esor-backend/models"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func GetPatients(c *gin.Context) {
	// 1. Pobieramy zmienną środowiskową, żeby sprawdzić na którym ENV działamy
	appEnv := os.Getenv("APP_ENV")
	if appEnv == "" {
		appEnv = "development"
	}

	// 2. Pobieramy listę pacjentów z bazy danych za pomocą GORM
	var patients []models.Patient
	result := config.DB.Find(&patients)
	
	if result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Nie udało się pobrać pacjentów: " + result.Error.Error(),
		})
		return
	}

	// 3. Zwracamy pacjentów w formacie JSON oraz dodajemy nagłówek z informacją o ENV dla testu
	c.Header("X-App-Env", appEnv)
	c.JSON(http.StatusOK, patients)
}