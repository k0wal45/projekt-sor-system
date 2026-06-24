# System Wspomagania Klasyfikacji Pacjentów (E-SOR)

Inteligentny system wspomagania decyzji medycznych przeznaczony do automatyzacji segregacji pacjentów (Triage) na Szpitalnych Oddziałach Ratunkowych zgodnie ze standardem KTAS. Projekt łączy w sobie architekturę mikroserwisową, przetwarzanie w czasie rzeczywistym oraz wnioskowanie z użyciem sztucznej inteligencji.

## Architektura Systemu

- **Frontend (Flutter):** Reaktywna aplikacja kliencka implementująca wzorzec MVVM, połączona z backendem za pomocą zapytań REST API (Dio) oraz asynchronicznych strumieni WebSocket.

- **Backend API (Go / Gin):** Wysokowydajny serwer orkiestrujący logikę biznesową, autoryzację JWT, transakcje bazodanowe oraz dystrybucję zdarzeń WebSocket (Goroutines).

- **Baza Danych (PostgreSQL 15):** Trwałe i transakcyjne przechowywanie zoptymalizowanych struktur danych mapowanych obiektowo przez GORM.

- **AI Core (Python / FastAPI):** Odizolowany serwis predykcyjny realizujący inferencję matematyczną (Decision Tree) na podstawie wektora parametrów życiowych pacjenta.

- **Infrastruktura (Docker & Tailscale):** Pełna konteneryzacja stosu (Docker Compose) uruchomiona w architekturze Homelab, zabezpieczona siecią kratową Mesh VPN.

## Architektura Środowiskowa (Multi-Environment Setup)

Backend w Go dynamicznie zarządza źródłem danych na podstawie zmiennych środowiskowych .env, eliminując potrzebę modyfikacji konfiguracji Docker Compose:

1.  **Development (APP_ENV=development, IS_SERVER=false):** Backend i baza działają lokalnie na stacji dewelopera w tej samej sieci Docker.

2.  **Hybrydowe (APP_ENV=production, IS_SERVER=false):** Backend uruchomiony na PC dewelopera przekierowuje zapytania SQL na zewnętrzny adres SERVER_IP (serwera domowego), umożliwiając pracę na realnych danych.

3.  **Produkcja (APP_ENV=production, IS_SERVER=true):** Kontenery działają bezpośrednio na domowym serwerze Ubuntu, izolując porty przed ruchem WAN.

## Konfiguracja Zmiennych Środowiskowych (.env)

Wymagane jest utworzenie pliku .env w katalogu głównym projektu (zsynchronizowanego z rzeczywistymi portami i punktami końcowymi Twojego API):

```env
APP_ENV=production
IS_SERVER=true
SERVER_IP=100.114.242.128 # Adres IP serwera w sieci Tailscale

DB_USER=admin
DB_PASSWORD=silne_haslo_produkcyjne
DB_NAME=sor_system
DB_PORT=5432

# Adres URL do wewnętrznego punktu końcowego inferencji AI
AI_SERVICE_URL=http://ai:8000/api/triage
JWT_SECRET=naszSekretnyKodPodpisuJWT

```

---

## Szybkie Uruchomienie (Docker Compose)

Do uruchomienia kompletnego środowiska backendowego wymagany jest zainstalowany Docker. Projekt nie korzysta z potoków CI/CD, wdrożenia realizowane są manualnie.

```bash

# Sklonowanie repozytorium

git clone [https://github.com/kowal45/projekt-sor-system.git](https://github.com/kowal45/projekt-sor-system.git)

cd projekt-sor-system



# Uruchomienie wszystkich mikroserwisów w tle

docker compose up -d --build
```

### Przydatne komendy deweloperskie

- **Wymuszenie czystej rekompilacji backendu (Multi-stage Go build):**

```bash
docker compose up -d --build sor_backend
```

- **Pełny reset wolumenów bazy danych (Wyczyszczenie testowych rekordów):**

```bash
docker compose down -v

docker compose up -d
```

- **Podgląd logów i stanu preloading'u relacji w GORM:**

```bash
docker logs -f sor_backend
```

---

## Przepływ Klasyfikacji Medycznej (Triage)

1. **Ekstrakcja i Selekcja:** Serwer Go przyjmuje parametry życiowe pacjenta z aplikacji Flutter, wyciąga datę urodzenia i oblicza wiek z bazy PostgreSQL.

2. **Komunikacja Blokująca:** Parametry (age, hr, sbp, dbp, pain_lvl) są serializowane do JSON i wysyłane synchronicznym żądaniem HTTP POST do kontenera sor_ai.

3. **Inferencja ML:** FastAPI ładuje z plików .pickle strukturę drzewa decyzyjnego, wykonuje predykcję w czasie milisekundowym i zwraca kod pilności KTAS (1-5), gwarantując 100% czułości dla stanów krytycznych.

4. **Dystrybucja Real-time:** Backend aktualizuje status pacjenta w bazie i asynchronicznie wypycha zaktualizowaną strukturę kolejki przez WebSocket (BroadcastQueue) do wszystkich paneli personelu oraz monitora poczekalni.

## Schemat bazy danych

```
└── /api
    ├── 🔓 /auth (Trasy otwarte)
    │   └── POST /login ──────────────────────── Logowanie personelu
    ├── 🔓 /auth (Trasy otwarte)
    │   └── POST /login ──────────────────────── Logowanie personelu
    │
    └── 🔒 / (Wymaga AuthMiddleware - JWT)
        ├── GET /auth/me ─────────────────────── Profil zalogowanego użytkownika
        ├── POST /auth/register ──────────────── Rejestracja pracownika [ADMIN]
        │
        ├── 👥 /patients (Zarządzanie kartotekami)
        │   ├── POST /patients ───────────────── Rejestracja nowej karty pacjenta
        │   ├── GET  /patients ───────────────── Dynamiczne filtrowanie pacjentów
        │   ├── GET  /patients/:pesel ────────── Wyszukiwanie (PESEL)
        │   ├── PUT  /patients/:pesel ────────── Aktualizacja danych metrykalnych
        │   └── DELETE /patients/:pesel ──────── Usunięcie kartoteki [ADMIN, LEKARZ]
        │
        ├── 🏥 /admissions (Przyjęcia i Triage SOR)
        │   ├── POST /admissions/predict-ktas ── Bezstanowa inferencja (FastAPI AI Core)
        │   ├── POST /admissions ─────────────── Zapis karty Triage (Kolejka SOR)
        │   ├── GET  /ws/admissions/queue ────── Strumień WebSocket (Czas rzeczywisty)
        │   ├── GET  /admissions ─────────────── Archiwum przyjęć oddziałowych
        │   ├── PATCH /admissions/:id/status ──── Zmiana statusu procesu obsługi
        │   └── GET  /patients/:pesel/admissions Historyczna kartoteka wizyt pacjenta
        │
        └── 🩺 [LEKARZ, ADMIN] (Panel gabinetowy i diagnostyka)
            ├── GET  /doctor/admissions ──────── Pacjenci przypisani do lekarza
            ├── PUT  /admissions/:id/assign ──── Przejęcie pacjenta z poczekalni
            ├── POST /consultations ──────────── Zamknięcie karty (ICD-10, wypis)
            └── POST /diagnostic-orders ──────── Zlecenie badania (RTG, KREW, TK)
```
