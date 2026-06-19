package models

import "time"

type DiagnosticOrder struct {
	ID          uint      `gorm:"primaryKey" json:"id"`
	AdmissionID uint      `gorm:"not null;column:id_przyjecia" json:"id_przyjecia"`
	DoctorID    uint      `gorm:"not null;column:id_lekarza" json:"id_lekarza"`
	TestType    string    `gorm:"column:typ_badania" json:"typ_badania"` // np. KREW, RTG, EKG, TK
	Description string    `gorm:"type:text;column:opis_zlecenia" json:"opis_zlecenia"`
	Status      string    `gorm:"default:'ZLECONE';column:status_badania" json:"status_badania"` // ZLECONE, W_REALIZACJI, GOTOWE
	CreatedAt   time.Time `json:"data_zlecenia"`
}