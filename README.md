# System Wspomagania Klasyfikacji Pacjentów (SOR Triage)

Projekt łączony na 4 przedmioty akademickie.

## Architektura
- **Front-end:** Aplikacja Mobilna (oddzielnie)
- **Backend:** Python (FastAPI) - Kontener Docker
- **Baza Danych:** SQL (PostgreSQL) - Kontener Docker
- **Algorytm AI:** Python (Scikit-learn/PyTorch) - Kontener Docker

## Jak uruchomić (Development)
Wymagany zainstalowany Docker oraz Docker Compose.

```bash
git clone [URL_TWOJEGO_REPO]
cd system-sor
docker-compose up -d
