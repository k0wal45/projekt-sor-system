package config

import (
	"esor-backend/models"
	"fmt"
	"log"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

var DB *gorm.DB

func ConnectDatabase() {
	appEnv := os.Getenv("APP_ENV")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	dbname := os.Getenv("DB_NAME")
	serverIP := os.Getenv("SERVER_IP")
	isServer := os.Getenv("IS_SERVER")

	if appEnv == "" {
		appEnv = "development"
	}

	dbHost := "db"

	if appEnv == "production" && isServer != "true" {
		dbHost = serverIP
		log.Printf("Przełączono źródło danych: %s wymusza połączenie z zewnętrznym serwerem (%s)", appEnv, dbHost)
	}

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=5432 sslmode=disable",
		dbHost, user, password, dbname)

	var gormConfig gorm.Config
	if appEnv == "development" {
		gormConfig.Logger = logger.Default.LogMode(logger.Info)
	} else {
		gormConfig.Logger = logger.Default.LogMode(logger.Error)
	}

	database, err := gorm.Open(postgres.Open(dsn), &gormConfig)
	if err != nil {
		log.Fatalf("Nie udało się połączyć z bazą (%s): %v", dbHost, err)
	}

	log.Printf("Połączono pomyślnie ze środowiskiem [%s] na hoście: %s", appEnv, dbHost)
	DB = database

	// 1. Inicjalizacja wszystkich typów ENUM
	initializeEnums()

	// 2. Automatyczna migracja tabel w bezpiecznej kolejności relacji
	log.Println("🚀 Uruchamianie bezpiecznej Auto-Migracji GORM...")
	migrateErr := DB.AutoMigrate(
		&models.Staff{},     // Brak kluczy obcych
		&models.Patient{},   // Brak kluczy obcych
		&models.Admission{}, // Zależy od Staff i Patient (id_pacjenta, id_osoby_przyjmujacej)
		&models.Consultation{},
    &models.DiagnosticOrder{},
	)
	
	if migrateErr != nil {
		log.Fatalf("Krytyczny błąd podczas automatycznej migracji bazy danych: %v", migrateErr)
	}

	log.Println("✅ Struktura bazy danych została pomyślnie zsynchronizowana.")
}

// Funkcja pomocnicza tworząca wszystkie potrzebne typy ENUM w PostgreSQL
func initializeEnums() {
	log.Println("⚡ Sprawdzanie i inicjalizacja typów wyliczeniowych (ENUM) w PostgreSQL...")

	enums := map[string]string{
		"role_enum":             "CREATE TYPE role_enum AS ENUM ('PIELEGNIARZ', 'RATOWNIK', 'LEKARZ', 'ADMIN');",
		"gender_enum":           "CREATE TYPE gender_enum AS ENUM ('M', 'K', 'INNY');",
		"blood_group_enum":      "CREATE TYPE blood_group_enum AS ENUM ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', '0+', '0-');",
		"arrival_mode_enum":     "CREATE TYPE arrival_mode_enum AS ENUM ('Pieszo', 'Karetka publiczna', 'Pojazd prywatny', 'Karetka prywatna', 'Inne');",
		"mental_status_enum":    "CREATE TYPE mental_status_enum AS ENUM ('W pełni świadomy', 'Reaguje na głos', 'Reaguje tylko na ból', 'Nieprzytomny/Brak reakcji');",
		"admission_status_enum": "CREATE TYPE admission_status_enum AS ENUM ('W_POCZEKALNI', 'W_GABINECIE', 'OCZEKUJE_NA_WYNIKI', 'ZAKONCZONE');",
	}

	for typeName, createQuery := range enums {
		checkQuery := fmt.Sprintf("SELECT 1 FROM pg_type WHERE typname = '%s';", typeName)
		var exists int
		
		// Sprawdź czy enum istnieje
		err := DB.Raw(checkQuery).Scan(&exists).Error
		if err != nil {
			log.Fatalf("Błąd podczas sprawdzania enuma %s: %v", typeName, err)
		}

		// Jeśli nie istnieje (brak wierszy), utwórz go
		if exists == 0 {
			log.Printf("-> Tworzenie brakującego typu ENUM: %s", typeName)
			if err := DB.Exec(createQuery).Error; err != nil {
				log.Fatalf("Krytyczny błąd podczas tworzenia enuma %s: %v", typeName, err)
			}
		}
	}
}