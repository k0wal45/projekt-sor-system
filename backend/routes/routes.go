package routes

import (
	"esor-backend/controllers"
	"esor-backend/middleware" // <-- Importujemy nasz nowy middleware

	"github.com/gin-gonic/gin"
)

func SetupRouter(r *gin.Engine) {
	
	api := r.Group("/api")
	{
		// 1. TRASY OTWARTE (Publiczne / Autoryzacja)
		auth := api.Group("/auth")
		{
			auth.POST("/register", controllers.RegisterStaff)
			auth.POST("/login", controllers.LoginStaff)
		}

		// 2. TRASY ZABEZPIECZONE (Wymagają zalogowania - tokenu JWT)
		protected := api.Group("/")
		protected.Use(middleware.AuthMiddleware()) // Każda trasa poniżej przechodzi przez weryfikację tokenu
		{
			protected.GET("/auth/me", controllers.GetMe)

			// Moduł Pacjentów (CRUD podstawowy)
			protected.POST("/patients", controllers.CreatePatient)
			protected.GET("/patients", controllers.GetPatients)
			protected.GET("/patients/:pesel", controllers.GetPatientByPesel)
			protected.PUT("/patients/:pesel", controllers.UpdatePatient)
			protected.DELETE("/patients/:pesel", controllers.DeletePatient)
		}
	}
}