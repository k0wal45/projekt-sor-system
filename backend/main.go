package main

import (
	"esor-backend/config"
	"esor-backend/routes"

	"github.com/gin-gonic/gin"
)

func main() {
	// 1. Podłączenie do bazy (GORM)...
	config.ConnectDatabase()
	
	// 2. Inicjalizacja Gina
	r := gin.Default()

	// 3. Wstrzyknięcie naszych poukładanych ścieżek
	routes.SetupRouter(r)

	// 4. Start serwera
	r.Run(":8080")
}