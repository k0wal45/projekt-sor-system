package routes

import (
	"esor-backend/controllers" // Importujesz swoje kontrolery

	"github.com/gin-gonic/gin"
)

// SetupRouter konfiguruje wszystkie endpointy
func SetupRouter(r *gin.Engine) {
	
	// Tworzymy główną grupę dla API (dobra praktyka to wersjonowanie)
	api := r.Group("/api/")
	{
		// Grupa dla pacjentów (odpowiednik folderu /api/patients w Next)
		patients := api.Group("/patients")
		{
			patients.GET("/", controllers.GetPatients)
			patients.POST("/", controllers.CreatePatient)
			// patients.GET("/:id", controllers.GetPatientByID)
		}

		// Grupa dla wizyt (sor_visits)
		// visits := api.Group("/visits")
		// {
		// 	visits.POST("/", controllers.CreateVisit) // Tutaj w przyszłości uderzymy do AI
		// }
	}
}