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

	log.Println("⚡ Inicjalizacja typów wyliczeniowych (ENUM) w PostgreSQL...")
	enumErr := DB.Exec(`
		DO $$ 
		BEGIN 
			-- 1. Rola personelu medycznego
			IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'role_enum') THEN 
				CREATE TYPE role_enum AS ENUM ('PIELEGNIARZ', 'RATOWNIK', 'LEKARZ', 'ADMIN'); 
			END IF;
			
			-- 2. Status przyjęcia na SOR
			IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'admission_status_enum') THEN 
				CREATE TYPE admission_status_enum AS ENUM ('W_POCZEKALNI', 'W_GABINECIE', 'OCZEKUJE_NA_WYNIKI', 'ZAKONCZONE'); 
			END IF;

			-- 3. Płeć pacjenta
			IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'gender_enum') THEN 
				CREATE TYPE gender_enum AS ENUM ('M', 'K', 'INNY'); 
			END IF;

			-- 4. Grupa krwi pacjenta
			IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'blood_group_enum') THEN 
				CREATE TYPE blood_group_enum AS ENUM ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', '0+', '0-'); 
			END IF;

			-- 5. Decyzja o postępowaniu
			IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'discharge_decision_enum') THEN 
				CREATE TYPE discharge_decision_enum AS ENUM ('DO_DOMU', 'NA_ODDZIAL', 'OIOM', 'ZGON'); 
			END IF;

			-- 6. Typ zleconego badania
			IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'order_type_enum') THEN 
				CREATE TYPE order_type_enum AS ENUM ('KREW', 'RTG', 'TK', 'USG', 'EKG', 'INNE'); 
			END IF;

			-- 7. Status zlecenia
			IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'order_status_enum') THEN 
				CREATE TYPE order_status_enum AS ENUM ('ZLECONE', 'W_TRAKCIE', 'WYNIK_GOTOWY'); 
			END IF;
		END $$;
	`).Error

	if enumErr != nil {
		log.Fatalf("krytyczny błąd podczas rejestracji typu role_enum: %v", enumErr)
	}

	log.Println("🚀 Uruchamianie Auto-Migracji GORM...")
	migrateErr := DB.AutoMigrate(
		&models.Staff{}, 
		&models.Patient{}, 
		&models.Admission{},
		&models.Consultation{},
		&models.DiagnosticOrder{},
	)
	if migrateErr != nil {
		log.Fatalf("Błąd podczas automatycznej migracji bazy danych: %v", migrateErr)
	}

	log.Println("Struktura bazy danych została pomyślnie zsynchronizowana.")
}