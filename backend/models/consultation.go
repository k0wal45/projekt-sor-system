package models

import "time"

type Consultation struct {
	ID                 uint      `gorm:"primaryKey" json:"id"`
	AdmissionID        uint      `gorm:"not null;column:id_przyjecia" json:"id_przyjecia"`
	DoctorID           uint      `gorm:"not null;column:id_lekarza" json:"id_lekarza"`
	Notes              string    `gorm:"type:text;column:wywiad_lekarski" json:"wywiad_lekarski"`
	Diagnosis          string    `gorm:"type:text;column:rozpoznanie_icd10" json:"rozpoznanie_icd10"`
	DischargeDecision  string    `gorm:"column:decyzja_wyjsciowa" json:"decyzja_wyjsciowa"` // np. WYPIS_DO_DOMU, TRANSFER_NA_ODDZIAL
	CreatedAt          time.Time `json:"data_konsultacji"`
}