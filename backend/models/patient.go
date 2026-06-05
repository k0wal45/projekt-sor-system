package models

import (
	"time"
)

// Definiujemy typy dla naszych ENUM-ów z bazy danych
type Gender string
const (
	GenderM    Gender = "M"
	GenderK    Gender = "K"
	GenderInny Gender = "INNY"
)

type BloodGroup string
const (
	BloodAPlus  BloodGroup = "A+"
	BloodAMinus BloodGroup = "A-"
	BloodBPlus  BloodGroup = "B+"
	BloodBMinus BloodGroup = "B-"
	BloodABPlus BloodGroup = "AB+"
	BloodABMinus BloodGroup = "AB-"
	BloodZeroPlus BloodGroup = "0+"
	BloodZeroMinus BloodGroup = "0-"
)

// Patient odzwierciedla tabelę "patients" w PostgreSQL
type Patient struct {
	ID                    uint       `gorm:"primaryKey;column:id" json:"id"`
	Pesel                 string     `gorm:"unique;not null;column:pesel" json:"pesel"`
	FirstName             string     `gorm:"column:first_name;not null" json:"first_name"`
	LastName              string     `gorm:"column:last_name;not null" json:"last_name"`
	DateOfBirth           time.Time  `gorm:"column:date_of_birth;not null" json:"date_of_birth"`
	Gender                Gender     `gorm:"type:gender_enum;column:gender;not null" json:"gender"`
	Address               string     `gorm:"column:address;not null" json:"address"`
	Phone                 string     `gorm:"column:phone;not null" json:"phone"`
	Email                 string     `gorm:"column:email" json:"email"`
	EmergencyContactName  string     `gorm:"column:emergency_contact_name;not null" json:"emergency_contact_name"`
	EmergencyContactPhone string     `gorm:"column:emergency_contact_phone;not null" json:"emergency_contact_phone"`
	BloodGroup            BloodGroup `gorm:"type:blood_group_enum;column:blood_group" json:"blood_group"`
	Allergies             string     `gorm:"column:allergies" json:"allergies"`
	ChronicDiseases       string     `gorm:"column:chronic_diseases" json:"chronic_diseases"`
	CreatedAt             time.Time  `gorm:"column:created_at;default:CURRENT_TIMESTAMP" json:"created_at"`
}

// TableName wskazuje GORM-owi dokładną nazwę tabeli w bazie (liczba mnoga)
func (Patient) TableName() string {
	return "patients"
}