package models

import (
	"time"
)

// AdmissionStatus reprezentuje typ dla enuma statusu przyjęcia
type AdmissionStatus string

const (
	StatusWPoczekalni    AdmissionStatus = "W_POCZEKALNI"
	StatusWGabinecie     AdmissionStatus = "W_GABINECIE"
	StatusOczekujeWyniki AdmissionStatus = "OCZEKUJE_NA_WYNIKI"
	StatusZakonczone     AdmissionStatus = "ZAKONCZONE"
)

// Admission odzwierciedla tabelę "admissions" w PostgreSQL
type Admission struct{
	ID                uint            `gorm:"primaryKey;column:id" json:"id"`
	PatientID         uint            `gorm:"column:patient_id;not null" json:"patient_id"`
	TriageStaffID     uint            `gorm:"column:triage_staff_id;not null" json:"triage_staff_id"`
	AttendingDoctorID *uint           `gorm:"column:attending_doctor_id" json:"attending_doctor_id"` // Wskaźnik, bo lekarz może być przypisany później (NULL)
	AdmissionTime     time.Time       `gorm:"column:admission_time;default:CURRENT_TIMESTAMP" json:"admission_time"`
	ArrivalMode       string          `gorm:"column:arrival_mode;not null" json:"arrival_mode"` // np. "ZRM", "Własny"
	Injuries          string          `gorm:"column:injuries" json:"injuries"`
	MentalStatus      string          `gorm:"column:mental_status" json:"mental_status"`
	PainLvl           int             `gorm:"column:pain_lvl" json:"pain_lvl"`

	// --- PARAMETRY ŻYCIOWE DLA MODUŁU AI (.pkl) ---
	HR  int     `gorm:"column:hr;not null" json:"hr"`   // Heart Rate (tętno)
	SBP int     `gorm:"column:sbp;not null" json:"sbp"` // Systolic Blood Pressure (skurczowe)
	DBP int     `gorm:"column:dbp;not null" json:"dbp"` // Diastolic Blood Pressure (rozkurczowe)
	RR  int     `gorm:"column:rr;not null" json:"rr"`   // Respiratory Rate (częstość oddechów)
	BT  float64 `gorm:"column:bt;type:numeric(3,1);not null" json:"bt"` // Body Temperature (temperatura)

	ChiefComplaint  string          `gorm:"column:chief_complaint;not null" json:"chief_complaint"`
	PriorityKtas    int             `gorm:"column:priority_ktas" json:"priority_ktas"` // Triage (1-5) wyliczony przez AI lub zmieniony przez człowieka
	IsAiPredicted   bool            `gorm:"column:is_ai_predicted;default:false" json:"is_ai_predicted"`
	StatusAdmission AdmissionStatus `gorm:"type:admission_status_enum;column:status_admission;default:'W_POCZEKALNI'" json:"status_admission"`

	// --- RELACJE  ---
	Patient			*Patient `gorm:"foreignKey:PatientID;constraint:OnDelete:RESTRICT;" json:"patient,omitempty"`
	TriageStaff		*Staff   `gorm:"foreignKey:TriageStaffID;constraint:OnDelete:RESTRICT;" json:"triage_staff,omitempty"`
	AttendingDoctor *Staff `gorm:"foreignKey:AttendingDoctorID;constraint:OnDelete:SET NULL;" json:"attending_doctor,omitempty"`
}

// TableName wskazuje GORM-owi dokładną nazwę tabeli w bazie danych
func (Admission) TableName() string {
	return "admissions"
}