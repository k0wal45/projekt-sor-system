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
	ID            uint      `gorm:"primaryKey;autoIncrement"`
	FirstName     string    `gorm:"type:varchar(50);not null"`
	LastName      string    `gorm:"type:varchar(50);not null"`
	AcademicTitle string    `gorm:"type:varchar(30)"`
	Role          Role      `gorm:"type:role_enum;not null"`
	LoginEmail    string    `gorm:"type:varchar(100);unique;not null"`
	PasswordHash  string    `gorm:"type:varchar(255);not null"`
	CreatedAt     time.Time `gorm:"default:CURRENT_TIMESTAMP"`
}

func (Staff) TableName() string {
	return "staff"
}