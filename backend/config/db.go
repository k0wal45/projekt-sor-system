package config

import (
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
		log.Printf("🔄 Przełączono źródło danych: %s wymusza połączenie z zewnętrznym serwerem (%s)", appEnv, dbHost)
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

	log.Printf("✅ Połączono pomyślnie ze środowiskiem [%s] na hoście: %s", appEnv, dbHost)
	DB = database
}