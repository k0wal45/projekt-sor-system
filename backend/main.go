package main

import (
	"esor-backend/config"
	"esor-backend/routes"
	"esor-backend/utils"
	"log"
	"os" // <-- Natywny pakiet do obsługi zmiennych systemowych

	"github.com/gin-gonic/gin"
)

func main() {
	// Sprawdzamy w jakim środowisku startujemy
	appEnv := os.Getenv("APP_ENV")
	if appEnv == "" {
		appEnv = "development"
	}
	log.Printf("Uruchamianie serwera E-SOR w trybie: [%s]", appEnv)

	// 1. Inicjalizacja klucza JWT bezpośrednio z systemu
	utils.InitJWTSecret()

	// 2. Podłączenie do bazy (GORM) i Auto-Migracja
	config.ConnectDatabase()
	
	// 3. Konfiguracja trybu działania frameworku Gin
	if appEnv == "production" {
		gin.SetMode(gin.ReleaseMode) // Wyłącza debugowe logi Gina na produkcji
	}

	// 4. Inicjalizacja Gina
	r := gin.Default()

	// 5. Wstrzyknięcie ścieżek API
	routes.SetupRouter(r)

	// 6. Start serwera na porcie :8080
	log.Println("Serwer nasłuchuje na porcie :8080")
	r.Run(":8080")
}