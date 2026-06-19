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

-- Nowe ENUM-y dla zaktualizowanego procesu Triage/Admissions:
CREATE TYPE arrival_mode_enum AS ENUM ('Pieszo', 'Karetka publiczna', 'Pojazd prywatny', 'Karetka prywatna', 'Inne');
CREATE TYPE mental_status_enum AS ENUM ('W pełni świadomy', 'Reaguje na głos', 'Reaguje tylko na ból', 'Nieprzytomny/Brak reakcji');

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

-- Tabela 3: Przyjęcie na SOR (Admissions) - ZAKTUALIZOWANA
CREATE TABLE admissions (
    id SERIAL PRIMARY KEY,
    id_pacjenta INTEGER NOT NULL REFERENCES patients(id) ON DELETE RESTRICT,
    id_osoby_przyjmujacej INTEGER NOT NULL REFERENCES staff(id) ON DELETE RESTRICT,
    id_lekarza_prowadzacego INTEGER REFERENCES staff(id) ON DELETE SET NULL DEFAULT NULL,
    data_przyjecia TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    forma_przybycia arrival_mode_enum NOT NULL,
    injury BOOLEAN NOT NULL DEFAULT FALSE,
    mental_status mental_status_enum NOT NULL,
    pain BOOLEAN NOT NULL DEFAULT FALSE,
    pain_lvl INTEGER NOT NULL CHECK (pain_lvl >= 0 AND pain_lvl <= 10), -- skala NRS 0-10
    
    -- Parametry życiowe (Wartości numeryczne)
    hr INTEGER NOT NULL,          -- Heart Rate (tętno)
    sbp INTEGER NOT NULL,         -- Systolic Blood Pressure (skurczowe)
    dbp INTEGER NOT NULL,         -- Diastolic Blood Pressure (rozkurczowe)
    rr INTEGER NOT NULL,          -- Respiratory Rate (częstość oddechów)
    bt NUMERIC(3,1) NOT NULL,     -- Body Temperature (temperatura, np. 36.6)
    
    chief_complaint TEXT NOT NULL,
    priority_ktas INTEGER NOT NULL CHECK (priority_ktas >= 1 AND priority_ktas <= 5),
    is_ai_predicted BOOLEAN DEFAULT FALSE,
    status_przyjecia admission_status_enum DEFAULT 'W_POCZEKALNI'
);

-- Tabela 4: Konsultacja Lekarska (Consultations)
CREATE TABLE consultations (
    id SERIAL PRIMARY KEY,
    admission_id INTEGER UNIQUE NOT NULL REFERENCES admissions(id) ON DELETE CASCADE, -- Relacja 1-do-1
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

-- =========================================================================
-- 3. INDEKSY OPTYMALIZACYJNE
-- =========================================================================
CREATE INDEX idx_admissions_status_przyjecia ON admissions(status_przyjecia);
CREATE INDEX idx_admissions_priority_ktas ON admissions(priority_ktas);