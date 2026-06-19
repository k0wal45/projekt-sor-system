package models

import (
	"time"
)

// Definiujemy typy dla nowych ENUM-ów z bazy danych
type ArrivalMode string
const (
	ArrivalPieszo           ArrivalMode = "Pieszo"
	ArrivalKaretkaPubliczna ArrivalMode = "Karetka publiczna"
	ArrivalPojazdPrywatny   ArrivalMode = "Pojazd prywatny"
	ArrivalKaretkaPrywatna  ArrivalMode = "Karetka prywatna"
	ArrivalInne             ArrivalMode = "Inne"
)

type MentalStatus string
const (
	MentalSwiadomy     MentalStatus = "W pełni świadomy"
	MentalReagujeGlos  MentalStatus = "Reaguje na głos"
	MentalReagujeBol   MentalStatus = "Reaguje tylko na ból"
	MentalNieprzytomny MentalStatus = "Nieprzytomny/Brak reakcji"
)

type AdmissionStatus string
const (
	StatusWPoczekalni      AdmissionStatus = "W_POCZEKALNI"
	StatusWGabinecie       AdmissionStatus = "W_GABINECIE"
	StatusOczekujeNaWyniki AdmissionStatus = "OCZEKUJE_NA_WYNIKI"
	StatusZakonczone       AdmissionStatus = "ZAKONCZONE"
)

// Admission odzwierciedla zaktualizowaną tabelę "admissions"
type Admission struct {
	ID                  uint            `gorm:"primaryKey;column:id" json:"id"`
	
	// Powiązanie z Pacjentem
	PatientID           uint            `gorm:"column:id_pacjenta;not null" json:"id_pacjenta"`
	Patient             Patient         `gorm:"foreignKey:PatientID;references:ID;constraint:OnDelete:RESTRICT" json:"-"`
	
	// Powiązanie z Osobą Przyjmującą (Staff)
	TriageStaffID       uint            `gorm:"column:id_osoby_przyjmujacej;not null" json:"id_osoby_przyjmujacej"`
	TriageStaff         Staff           `gorm:"foreignKey:TriageStaffID;references:ID;constraint:OnDelete:RESTRICT" json:"-"`
	
	// Powiązanie z Lekarzem (Opcjonalne)
	AttendingDoctorID   *uint           `gorm:"column:id_lekarza_prowadzacego;default:NULL" json:"id_lekarza_prowadzacego"`
	AttendingDoctor     *Staff          `gorm:"foreignKey:AttendingDoctorID;references:ID;constraint:OnDelete:SET NULL" json:"-"`
	
	AdmissionTime       time.Time       `gorm:"column:data_przyjecia;default:CURRENT_TIMESTAMP" json:"data_przyjecia"`
	ArrivalMode         ArrivalMode     `gorm:"type:arrival_mode_enum;column:forma_przybycia;not null" json:"forma_przybycia"`
	Injury              bool            `gorm:"column:injury;default:false" json:"injury"`
	MentalStatus        MentalStatus    `gorm:"type:mental_status_enum;column:mental_status;not null" json:"mental_status"`
	Pain                bool            `gorm:"column:pain;default:false" json:"pain"`
	PainLvl             int             `gorm:"column:pain_lvl;not null" json:"pain_lvl"`         
	HR                  int             `gorm:"column:hr;not null" json:"hr"`
	SBP                 int             `gorm:"column:sbp;not null" json:"sbp"`
	DBP                 int             `gorm:"column:dbp;not null" json:"dbp"`
	RR                  int             `gorm:"column:rr;not null" json:"rr"`
	BT                  float64         `gorm:"type:numeric(3,1);column:bt;not null" json:"bt"`
	ChiefComplaint      string          `gorm:"column:chief_complaint;not null" json:"chief_complaint"`
	PriorityKtas        int             `gorm:"column:priority_ktas;not null" json:"priority_ktas"` 
	IsAiPredicted       bool            `gorm:"column:is_ai_predicted;default:false" json:"is_ai_predicted"`
	StatusAdmission     AdmissionStatus `gorm:"type:admission_status_enum;column:status_przyjecia;default:'W_POCZEKALNI'" json:"status_przyjecia"`
}

func (Admission) TableName() string {
	return "admissions"
}

