# System Wspomagania Klasyfikacji Pacjentów (SOR Triage)

Projekt łączony na 4 przedmioty akademickie.

## Architektura

- **Front-end:** Aplikacja Mobilna (oddzielnie)
- **Backend:** GO () - Kontener Docker
- **Baza Danych:** SQL (PostgreSQL) - Kontener Docker
- **Algorytm AI:** Python (Scikit-learn/PyTorch) - Kontener Docker

## Jak uruchomić (Development)

Wymagany zainstalowany Docker oraz Docker Compose.


git clone [URL_TWOJEGO_REPO]
cd system-sor
docker-compose up --build -d

## ⚙️ Backend

Serce systemu ESOR (Emergency Department Triage), odpowiedzialne za orkiestrację danych pomiędzy aplikacją mobilną, relacyjną bazą danych oraz zewnętrznym modułem Sztucznej Inteligencji.

Backend został zaprojektowany w architekturze mikroserwisowej i napisany w języku **Go (Golang)**, co gwarantuje wysoką wydajność, bezpieczeństwo typów i minimalne zużycie zasobów (skompilowana aplikacja działa jako pojedynczy, lekki plik binarny wewnątrz kontenera Docker).

### 🛠 Wykorzystane technologie
* **Język:** Go 1.22
* **Framework Webowy / Router:** Gin Gonic (szybka obsługa żądań HTTP i grupowanie ścieżek REST API)
* **ORM:** GORM (obiektowo-relacyjne mapowanie z wykorzystaniem mechanizmu Auto-Migracji)
* **Baza Danych:** PostgreSQL 15
* **Architektura:** Wieloetapowe budowanie obrazów (Multi-stage Docker build)

### 📡 Przepływ danych (Logika działania)
1. Backend udostępnia strukturyzowane REST API (np. `/api/v1/patients`, `/api/v1/visits`) dla aplikacji mobilnej, odbierając dane medyczne w formacie JSON.
2. Po walidacji, dane (parametry życiowe, wiek, ból) są trwale zapisywane w bazie PostgreSQL.
3. Następnie backend wykonuje wewnętrzne odpytanie (HTTP POST) do niezależnego kontenera AI (Python), przesyłając niezbędne cechy pacjenta.
4. Po otrzymaniu wyliczonego priorytetu od modelu uczenia maszynowego, backend aktualizuje rekord w bazie i zwraca ostateczny wynik do frontendu.

### 🚀 Uruchomienie lokalne
Aplikacja jest w pełni skonteneryzowana i nie wymaga instalacji środowiska Go na maszynie hosta. Aby uruchomić backend wraz z bazą danych i pozostałymi serwisami, wystarczy wykonać w głównym katalogu projektu polecenie:

