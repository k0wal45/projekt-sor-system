package config

import (
	"log"
	"os"
	"time"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// DB to globalna zmienna, do której będziemy się odwoływać w kontrolerach
var DB *gorm.DB

func ConnectDatabase() {
	// 1. Pobranie zmiennych z systemu (wstrzykniętych przez plik .env w Dockerze)
	dbURL := os.Getenv("DATABASE_URL")
	appEnv := os.Getenv("APP_ENV")

	if dbURL == "" {
		log.Fatal("Błąd: Zmienna środowiskowa DATABASE_URL nie została ustawiona!")
	}

	// 2. Konfiguracja loggera GORM w zależności od środowiska
	var gormConfig gorm.Config
	if appEnv == "development" {
		log.Println("🔧 Tryb deweloperski: Włączam szczegółowy logger SQL...")
		gormConfig.Logger = logger.New(
			log.New(os.Stdout, "\r\n", log.LstdFlags),
			logger.Config{
				SlowThreshold:             time.Second,
				LogLevel:                  logger.Info, // Wypisuje wszystkie zapytania SQL
				IgnoreRecordNotFoundError: true,
				Colorful:                  true,
			},
		)
	} else {
		log.Println("🚀 Tryb produkcyjny: Logger SQL ograniczony do błędów.")
		gormConfig.Logger = logger.Default.LogMode(logger.Error)
	}

	// 3. Nawiązanie połączenia
	database, err := gorm.Open(postgres.Open(dbURL), &gormConfig)
	if err != nil {
		log.Fatalf("Nie udało się połączyć z bazą danych: %v", err)
	}

	log.Println("✅ Połączenie z bazą danych PostgreSQL ustanowione pomyślnie!")
	DB = database
}