package routes

import (
	"esor-backend/controllers"
	"esor-backend/middleware"

	"github.com/gin-gonic/gin"
)

func SetupRouter(r *gin.Engine) {
	
	r.GET("/api/ws/admissions/public-queue", controllers.HandlePublicQueueWebSocket)
	
	api := r.Group("/api")
	{

		// 1. TRASY OTWARTE (Publiczne dla każdego)
		auth := api.Group("/auth")
		{
			// Logowanie musi być publiczne, aby użytkownik mógł w ogóle dostać token
			auth.POST("/login", controllers.LoginStaff)
		}

		// 2. TRASY ZABEZPIECZONE (Wymagają zalogowania - tokenu JWT)
		protected := api.Group("/")
		protected.Use(middleware.AuthMiddleware()) // Każda trasa poniżej przechodzi przez weryfikację tokenu
		{
			// Profil aktualnego użytkownika (dostępny dla każdej zalogowanej roli)
			protected.GET("/auth/me", controllers.GetMe)

			// REJESTRACJA NOWEGO PERSONELU - Tylko ADMIN może tworzyć konta
			protected.POST("/auth/register", middleware.RoleBlockMiddleware("ADMIN"), controllers.RegisterStaff)

			// Moduł Pacjentów (Dostęp dla całego personelu medycznego)
			// Możesz tu też ograniczyć np. usuwanie tylko dla ADMINA i LEKARZA
			protected.POST("/patients", controllers.CreatePatient)
			protected.GET("/patients", controllers.GetPatients)
			protected.GET("/patients/:pesel", controllers.GetPatientByPesel)
			protected.PUT("/patients/:pesel", controllers.UpdatePatient)
			protected.DELETE("/patients/:pesel", middleware.RoleBlockMiddleware("ADMIN", "LEKARZ"), controllers.DeletePatient)
		
			// Moduł Przyjęć i Triage (Ekran Ratownika/Pielęgniarki)
			protected.POST("/admissions/predict-ktas", controllers.PredictKtas)
			protected.POST("/admissions", controllers.CreateAdmission)
			protected.GET("/ws/admissions/queue", controllers.StreamQueue)
			protected.GET("/admissions", controllers.GetAdmissions)
			protected.GET("/admissions/history", controllers.GetAdmissionsHistory)
			
			protected.GET("/admissions/:id", controllers.GetAdmissionByID)
			protected.DELETE("/admissions/:id", controllers.CancelAdmission)
			protected.PATCH("/admissions/:id/status", controllers.UpdateAdmissionStatus)
			
			// Historia medyczna danego pacjenta
			protected.GET("/patients/:pesel/admissions", controllers.GetPatientAdmissions)

			doctorGroup := protected.Group("")
			doctorGroup.Use(middleware.RoleBlockMiddleware("LEKARZ", "ADMIN"))
			{
				doctorGroup.GET("/doctor/admissions", controllers.GetDoctorAdmissions)
				doctorGroup.PUT("/admissions/:id/assign", controllers.AssignPatientToDoctor)
				doctorGroup.POST("/consultations", controllers.CreateConsultation)
				doctorGroup.POST("/diagnostic-orders", controllers.CreateDiagnosticOrder)
			}

			protected.GET("/staff", controllers.GetStaffList)
		}
		
		
	}
}