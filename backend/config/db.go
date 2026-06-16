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
			IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'role_enum') THEN 
				CREATE TYPE role_enum AS ENUM ('PIELEGNIARZ', 'RATOWNIK', 'LEKARZ', 'ADMIN'); 
			END IF; 
		END $$;
	`).Error

	if enumErr != nil {
		log.Fatalf("krytyczny błąd podczas rejestracji typu role_enum: %v", enumErr)
	}

	log.Println("🚀 Uruchamianie Auto-Migracji GORM...")
	migrateErr := DB.AutoMigrate(&models.Staff{})
	if migrateErr != nil {
		log.Fatalf("Błąd podczas automatycznej migracji bazy danych: %v", migrateErr)
	}

	log.Println("Struktura bazy danych została pomyślnie zsynchronizowana.")
}