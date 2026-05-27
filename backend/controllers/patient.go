package controllers

import "github.com/gin-gonic/gin"

// To odpali się np. przy GET /api/patients
func GetPatients(c *gin.Context) {
	c.JSON(200, gin.H{"message": "Lista wszystkich pacjentów"})
}

// To odpali się przy POST /api/patients
func CreatePatient(c *gin.Context) {
	// Tu w przyszłości odczytasz JSON i zapiszesz w GORM
	c.JSON(201, gin.H{"message": "Dodano nowego pacjenta"})
}