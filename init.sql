-- =========================================================================
-- 1. TWORZENIE TYPÓW ENUM (Słowniki systemowe)
-- =========================================================================
CREATE TYPE gender_enum AS ENUM ('M', 'K', 'INNY');
CREATE TYPE blood_group_enum AS ENUM ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', '0+', '0-');
CREATE TYPE role_enum AS ENUM ('PIELEGNIARZ', 'RATOWNIK', 'LEKARZ', 'ADMIN');
CREATE TYPE admission_status_enum AS ENUM ('W_POCZEKALNI', 'W_GABINECIE', 'OCZEKUJE_NA_WYNIKI', 'ZAKONCZONE');
CREATE TYPE discharge_decision_enum AS ENUM ('DO_DOMU', 'NA_ODDZIAL', 'OIOM', 'ZGON');
CREATE TYPE order_type_enum AS ENUM ('KREW', 'RTG', 'TK', 'USG', 'EKG', 'INNE');
CREATE TYPE order_status_enum AS ENUM ('ZLECONE', 'W_TRAKCIE', 'WYNIK_GOTOWY');

-- =========================================================================
-- 2. TWORZENIE TABEL (W kolejności uwzględniającej klucze obce)
-- =========================================================================

-- Tabela 1: Pacjenci (Patients)
CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    pesel VARCHAR(11) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender gender_enum NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    emergency_contact_name VARCHAR(100) NOT NULL,
    emergency_contact_phone VARCHAR(20) NOT NULL,
    blood_group blood_group_enum,
    allergies TEXT,
    chronic_diseases TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela 2: Personel (Staff)
CREATE TABLE staff (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    academic_title VARCHAR(30), -- np. lek. med., dr n. med., mgr
    role role_enum NOT NULL,
    login_email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela 3: Przyjęcie na SOR (Admissions)
CREATE TABLE admissions (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id) ON DELETE RESTRICT,
    triage_staff_id INTEGER NOT NULL REFERENCES staff(id) ON DELETE RESTRICT,
    attending_doctor_id INTEGER REFERENCES staff(id) ON DELETE SET NULL, -- Domyślnie NULL, dopóki lekarz nie przejmie pacjenta
    admission_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    arrival_mode VARCHAR(100) NOT NULL, -- np. "ZRM", "Własny"
    injuries TEXT,
    mental_status VARCHAR(100), -- np. "Zorientowany", "Splątany"
    pain_lvl INTEGER CHECK (pain_lvl >= 0 AND pain_lvl <= 10), -- skala NRS 0-10
    
    -- Parametry życiowe
    hr INTEGER NOT NULL,          -- Heart Rate (tętno)
    sbp INTEGER NOT NULL,         -- Systolic Blood Pressure (skurczowe)
    dbp INTEGER NOT NULL,         -- Diastolic Blood Pressure (rozkurczowe)
    rr INTEGER NOT NULL,          -- Respiratory Rate (częstość oddechów)
    bt DECIMAL(3,1) NOT NULL,     -- Body Temperature (temperatura)
    
    chief_complaint TEXT NOT NULL,
    priority_ktas INTEGER CHECK (priority_ktas >= 1 AND priority_ktas <= 5),
    is_ai_predicted BOOLEAN DEFAULT FALSE,
    status_admission admission_status_enum DEFAULT 'W_POCZEKALNI'
);

-- Tabela 4: Konsultacja Lekarska (Consultations)
CREATE TABLE consultations (
    id SERIAL PRIMARY KEY,
    admission_id INTEGER UNIQUE NOT NULL REFERENCES admissions(id) ON DELETE CASCADE, -- Relacja 1-do-1 (jedna karta na jedno przyjęcie)
    medical_history TEXT NOT NULL,
    diagnosis TEXT NOT NULL,
    discharge_decision discharge_decision_enum NOT NULL,
    end_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela 5: Zlecenia Diagnostyczne (Diagnostic_Orders)
CREATE TABLE diagnostic_orders (
    id SERIAL PRIMARY KEY,
    admission_id INTEGER NOT NULL REFERENCES admissions(id) ON DELETE CASCADE,
    order_type order_type_enum NOT NULL,
    order_notes TEXT,
    order_status order_status_enum DEFAULT 'ZLECONE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);