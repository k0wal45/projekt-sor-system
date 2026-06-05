# System Wspomagania Klasyfikacji Pacjentów (SOR Triage)

Projekt łączony na 4 przedmioty akademickie.

## Architektura

- **Front-end:** Aplikacja Mobilna (rozwijana natywnie/hybrydowo poza środowiskiem kontenerów).
- **Backend API:** Napisany w języku **Go (Golang)** – zarządza logiką biznesową i komunikacją.
- **Baza Danych:** Relacyjna baza **PostgreSQL 15** przechowująca dane pacjentów i historię wizyt.
- **Moduł AI:** Mikrousługa w języku **Python (FastAPI)** realizująca klasyfikację pacjentów w oparciu o parametry życiowe.
- **DevOps & Automatyzacja:** Konteneryzacja (Docker & Docker Compose) sprzężona z mechanizmem automatycznej synchronizacji kodu źródłowego (`git-sync`).

## 🚀 Jak uruchomić (Development & Production)

Wymagany zainstalowany Docker oraz Docker Compose.

### Quick Start

```bash
git clone [URL_TWOJEGO_REPO]
cd system-sor
docker compose up -d --build

## ⚙️ Backend

Serce systemu ESOR (Emergency Department Triage), odpowiedzialne za orkiestrację danych pomiędzy aplikacją mobilną, relacyjną bazą danych oraz zewnętrznym modułem Sztucznej Inteligencji.

Backend został zaprojektowany w architekturze mikroserwisowej i napisany w języku **Go (Golang)**, co gwarantuje wysoką wydajność, bezpieczeństwo typów i minimalne zużycie zasobów (skompilowana aplikacja działa jako pojedynczy, lekki plik binarny wewnątrz kontenera Docker).

### 🛠 Wykorzystane technologie

- **Język:** Go 1.22
- **Framework Webowy / Router:** Gin Gonic (szybka obsługa żądań HTTP i grupowanie ścieżek REST API)
- **ORM:** GORM (obiektowo-relacyjne mapowanie z wykorzystaniem mechanizmu Auto-Migracji)
- **Baza Danych:** PostgreSQL 15
- **Architektura:** Wieloetapowe budowanie obrazów (Multi-stage Docker build)

### 📡 Przepływ danych (Logika działania)

1. Backend udostępnia strukturyzowane REST API (np. `/api/v1/patients`, `/api/v1/visits`) dla aplikacji mobilnej, odbierając dane medyczne w formacie JSON.
2. Po walidacji, dane (parametry życiowe, wiek, ból) są trwale zapisywane w bazie PostgreSQL.
3. Następnie backend wykonuje wewnętrzne odpytanie (HTTP POST) do niezależnego kontenera AI (Python), przesyłając niezbędne cechy pacjenta.
4. Po otrzymaniu wyliczonego priorytetu od modelu uczenia maszynowego, backend aktualizuje rekord w bazie i zwraca ostateczny wynik do frontendu.

### 🚀 Uruchomienie lokalne

Aplikacja jest w pełni skonteneryzowana i nie wymaga instalacji środowiska Go na maszynie hosta. Aby uruchomić backend wraz z bazą danych i pozostałymi serwisami, wystarczy wykonać w głównym katalogu projektu polecenie:
```
