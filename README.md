Oto zaktualizowana i rozbudowana treść pliku `README.md`, która uwzględnia nowo wdrożoną architekturę środowiskową (automatyczne przełączanie bazy za pomocą kodu w Go) oraz porządkuje sekcję zmiennych środowiskowych `.env`.

Dokument został zaprojektowany zgodnie z wymaganiami akademickimi – jest szczegółowy, profesjonalnie sformatowany i technicznie precyzyjny.

---

# System Wspomagania Klasyfikacji Pacjentów (SOR Triage)

Projekt łączony na 4 przedmioty akademickie.

## Architektura

- **Front-end:** Aplikacja Mobilna (rozwijana natywnie/hybrydowo poza środowiskiem kontenerów).
- **Backend API:** Napisany w języku **Go (Golang)** – zarządza logiką biznesową i komunikacją.
- **Baza Danych:** Relacyjna baza **PostgreSQL 15** przechowująca dane pacjentów i historię wizyt.
- **Moduł AI:** Mikrousługa w języku **Python (FastAPI)** realizująca klasyfikację pacjentów w oparciu o parametry życiowe.
- **DevOps & Automatyzacja:** Konteneryzacja (Docker & Docker Compose) sprzężona z mechanizmem automatycznej synchronizacji kodu źródłowego (`git-sync`).

## ⚙️ Architektura Środowiskowa (Multi-Environment Setup)

System wspiera inteligentne, automatyczne zarządzanie źródłem danych na poziomie kodu aplikacji w Go. Zależnie od konfiguracji pliku lokalnego `.env`, backend potrafi dynamicznie przełączać się pomiędzy lokalnym kontenerem bazy danych a fizycznym serwerem zewnętrznym, bez konieczności modyfikowania pliku `docker-compose.yml`.

### Tryby działania systemu:

1. **Środowisko Deweloperskie (`APP_ENV=development` na PC):** Backend komunikuje się z lokalnym kontenerem PostgreSQL (`db`) wewnątrz tej samej sieci Docker.
2. **Środowisko Hybrydowe (`APP_ENV=production` na PC):** Lokalny backend uruchomiony na komputerze dewelopera automatycznie wykrywa brak flagi serwera i przekierowuje zapytania do produkcyjnej bazy danych na serwerze zewnętrznym (`SERVER_IP`), umożliwiając testowanie aplikacji na realnych danych bez lokalnego narzutu.
3. **Środowisko Produkcyjne (`APP_ENV=production` oraz `IS_SERVER=true` na Serwerze):** Backend uruchomiony bezpośrednio na maszynie produkcyjnej rozpoznaje swoje środowisko docelowe i łączy się z bazą lokalnie poprzez izolowaną sieć Dockera (`db`), izolując porty przed światem zewnętrznym.

---

## 🔐 Konfiguracja Zmiennych Środowiskowych (`.env`)

Konfiguracja systemu opiera się na pliku `.env`, który jest ignorowany przez system kontroli wersji Git ze względów bezpieczeństwa. Poniżej znajdują się referencyjne wzorce konfiguracji dla obu maszyn.

### 💻 Plik `.env` na komputerze deweloperskim (PC)

```env
# Status środowiska (development / production)
APP_ENV=development
IS_SERVER=false
SERVER_IP=192.168.0.1  # Adres IP serwera Ubuntu

# Autentykacja bazy danych
DB_USER=admin
DB_PASSWORD=twoje_lokalne_haslo
DB_NAME=sor_system
DB_PORT=5432

# Adres URL do mikrousługi AI dla żądań Triage
AI_SERVICE_URL=http://ai:8000/predict

```

### 🌐 Plik `.env` na serwerze produkcyjnym (Ubuntu)

```env
# Status środowiska produkcyjnego
APP_ENV=production
IS_SERVER=true          # Zabezpieczenie informujące Go, że działa na serwerze docelowym
SERVER_IP=127.0.0.1

# Autentykacja bazy danych (Musi być identyczna jak na PC w trybie hybrydowym)
DB_USER=admin
DB_PASSWORD=silne_haslo_produkcyjne
DB_NAME=sor_system
DB_PORT=5432

# Adres URL do mikrousługi AI dla żądań Triage
AI_SERVICE_URL=http://ai:8000/predict

```

---

## 🚀 Jak uruchomić (Development & Production)

Wymagany zainstalowany Docker oraz Docker Compose (w nowej wersji, niewymagającej atrybutu `version` w plikach YAML).

### Szybkie uruchomienie projektu

```bash
git clone [URL_TWOJEGO_REPO]
cd system-sor
# Skonfiguruj plik .env zgodnie z powyższym wzorcem
docker compose up -d --build

```

### 🛠️ Zarządzanie i rozwiązywanie problemów (Troubleshooting)

**Wymuszenie czystej rekompilacji backendu (po zmianach w kodzie Go):**

```powershell
docker compose up -d --build backend

```

**Pełny reset bazy danych na maszynie deweloperskiej (Hard Reset wolumenów):**
W przypadku zmiany haseł strukturalnych w `.env`, należy zresetować zainicjalizowany wolumen bazy danych PostgreSQL za pomocą flagi `-v`:

```powershell
docker compose down -v
docker compose up -d

```

**Podgląd logów i stanu routingu bazy danych:**

```powershell
docker logs sor_backend

```

---

## ⚙️ Backend

Serce systemu ESOR (Emergency Department Triage), odpowiedzialne za orkiestrację danych pomiędzy aplikacją mobilną, relacyjną bazą danych oraz zewnętrznym modułem Sztucznej Inteligencji.

Backend został zaprojektowany w architekturze mikroserwisowej i napisany w języku **Go (Golang)**, co gwarantuje wysoką wydajność, bezpieczeństwo typów i minimalne zużycie zasobów (skompilowana aplikacja działa jako pojedynczy, lekki plik binarny wewnątrz kontenera Docker).

### 🛠 Wykorzystane technologie

- **Język:** Go 1.26 (Alpine-based compiler)
- **Framework Webowy / Router:** Gin Gonic (szybka obsługa żądań HTTP i grupowanie ścieżek REST API)
- **ORM:** GORM (obiektowo-relacyjne mapowanie z wykorzystaniem mechanizmu Auto-Migracji struktury bazodanowej)
- **Baza Danych:** PostgreSQL 15
- **Architektura:** Wieloetapowe budowanie obrazów (Multi-stage Docker build oparty o warstwę `builder` oraz produkcyjny, odchudzony obraz `alpine:latest`).

### 📡 Przepływ danych (Logika działania)

1. Backend udostępnia strukturyzowane REST API dla aplikacji mobilnej, odbierając dane medyczne w formacie JSON.
2. Po walidacji i dynamicznym wyborze hosta bazy przez moduł `config.ConnectDatabase()`, dane (parametry życiowe, wiek, poziom bólu) są trwale zapisywane w bazie PostgreSQL.
3. Następnie backend wykonuje wewnętrzne odpytanie (HTTP POST) do niezależnego kontenera AI (Python FastAPI), przesyłając wektor cech pacjenta.
4. Po otrzymaniu wyliczonego priorytetu od modelu uczenia maszynowego, backend aktualizuje rekord w bazie (przydzielając odpowiedni kolor kodu Triage) i zwraca ostateczny wynik w strukturze odpowiedzi do frontendu.
