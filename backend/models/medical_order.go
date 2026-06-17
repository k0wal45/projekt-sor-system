package models

import (
	"time"
)

// --- ENUMY DLA KONSULTACJI I ZLECEŃ ---
type DischargeDecision string
const (
	DecisionDoDomu    DischargeDecision = "DO_DOMU"
	DecisionNaOddzial DischargeDecision = "NA_ODDZIAL"
	DecisionOiom      DischargeDecision = "OIOM"
	DecisionZgon      DischargeDecision = "ZGON"
)

type OrderType string
const (
	OrderKrew OrderType = "KREW"
	OrderRtg  OrderType = "RTG"
	OrderTk   OrderType = "TK"
	OrderUsg  OrderType = "USG"
	OrderEkg  OrderType = "EKG"
	OrderInne OrderType = "INNE"
)

type OrderStatus string
const (
	StatusZlecone   OrderStatus = "ZLECONE"
	StatusWTrakcie  OrderStatus = "W_TRAKCIE"
	StatusWynikGotowy OrderStatus = "WYNIK_GOTOWY"
)

// --- MAPOWANIE TABEL ---

// Consultation odzwierciedla tabelę "consultations" (Relacja 1-do-1 z Admission)
type Consultation struct {
	ID                uint              `gorm:"primaryKey;column:id" json:"id"`
	AdmissionID       uint              `gorm:"column:admission_id;unique;not null" json:"admission_id"` // Klucz unikalny zapewnia relację 1-do-1
	MedicalHistory    string            `gorm:"column:medical_history;not null" json:"medical_history"`
	Diagnosis         string            `gorm:"column:diagnosis;not null" json:"diagnosis"`
	DischargeDecision DischargeDecision `gorm:"type:discharge_decision_enum;column:discharge_decision;not null" json:"discharge_decision"`
	EndTime           time.Time         `gorm:"column:end_time;default:CURRENT_TIMESTAMP" json:"end_time"`

	// Relacja zwrotna do przyjęcia 
	Admission *Admission `gorm:"foreignKey:AdmissionID;constraint:OnDelete:CASCADE;" json:"admission,omitempty"`
}

func (Consultation) TableName() string {
	return "consultations"
}

// DiagnosticOrder odzwierciedla tabelę "diagnostic_orders" (Relacja Many-to-1 z Admission)
type DiagnosticOrder struct {
	ID          uint        `gorm:"primaryKey;column:id" json:"id"`
	AdmissionID uint        `gorm:"column:admission_id;not null" json:"admission_id"`
	OrderType   OrderType   `gorm:"type:order_type_enum;column:order_type;not null" json:"order_type"`
	OrderNotes  string      `gorm:"column:order_notes" json:"order_notes"`
	OrderStatus OrderStatus `gorm:"type:order_status_enum;column:order_status;default:'ZLECONE'" json:"order_status"`
	CreatedAt   time.Time   `gorm:"column:created_at;default:CURRENT_TIMESTAMP" json:"created_at"`

	// Relacja zwrotna do przyjęcia
	Admission *Admission `gorm:"foreignKey:AdmissionID;constraint:OnDelete:CASCADE;" json:"admission,omitempty"`
}

func (DiagnosticOrder) TableName() string {
	return "diagnostic_orders"
}