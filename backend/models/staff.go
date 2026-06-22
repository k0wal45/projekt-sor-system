package models

import (
	"time"
)

type Role string

const (
	RolePielegniarz Role = "PIELEGNIARZ"
	RoleRatownik    Role = "RATOWNIK"
	RoleLekarz      Role = "LEKARZ"
	RoleAdmin       Role = "ADMIN"
)

type Staff struct {
	ID            uint      `gorm:"primaryKey;column:id" json:"id"` // <--- ZMIANA: dodaj column:id
	FirstName     string    `gorm:"type:varchar(50);not null" json:"first_name"`
	LastName      string    `gorm:"type:varchar(50);not null" json:"last_name"`
	AcademicTitle string    `gorm:"type:varchar(30)" json:"academic_title"`
	Role          Role      `gorm:"type:role_enum;not null" json:"role"`
	LoginEmail    string    `gorm:"type:varchar(100);unique;not null" json:"login_email"`
	PasswordHash  string    `gorm:"type:varchar(255);not null" json:"-"` // Ukrywamy hasło w JSON
	CreatedAt     time.Time `gorm:"default:CURRENT_TIMESTAMP" json:"created_at"`
}

func (Staff) TableName() string {
	return "staff"
}