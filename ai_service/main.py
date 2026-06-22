import sys
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import pickle 

# Importujemy struktury z Twojego pliku tree_classes
import tree_classes

# --- FIX DLA UVICORNA W DOCKERZE (ZANIM KOD FUNKCJI SIĘ URUCHOMI) ---
# Wskazujemy pickle'owi, że klasy z '__main__' to w rzeczywistości klasy z tree_classes
sys.modules['__main__'].DecisionTreeClassifierRaw = tree_classes.DecisionTreeClassifierRaw
sys.modules['__main__'].DecisionNode = tree_classes.DecisionNode
# ------------------------------------------------------------------

app = FastAPI()

# --- BEZPIECZNE ŁADOWANIE MODELU RAZ PRZY STARCIE KONTENERA ---
MODEL_PATH = "drzewo_model.pickle"
try:
    with open(MODEL_PATH, 'rb') as file:
        modelAI = pickle.load(file)
    print(f"[SUKCES] Model {MODEL_PATH} został pomyślnie wczytany do pamięci RAM.")
except FileNotFoundError:
    print(f"[BŁĄD KRYTYCZNY] Nie znaleziono pliku {MODEL_PATH} w kontenerze!")
    modelAI = None
except Exception as e:
    print(f"[BŁĄD KRYTYCZNY] Podczas ładowania modelu wystąpił błąd: {str(e)}")
    modelAI = None


# 1. Definiujemy model danych pacjenta trafiających z backendu
class TriageRequest(BaseModel):
    age: int = Field(..., ge=0, le=120, description="Wiek pacjenta")
    hr: int = Field(..., ge=20, le=250, description="Tętno (bpm)")
    sbp: int = Field(..., ge=40, le=250, description="Ciśnienie skurczowe")
    dbp: int = Field(..., ge=40, le=250, description="Ciśnienie rozkurczowe")
    pain_lvl: int = Field(..., ge=0, le=10, description="Skala bólu od 0 do 10")

# Typowy słownik odpowiedzi z wynikami Triage
class TriageResponse(BaseModel):
    priority_level: int # 1 (najwyższy) do 5 (najniższy)

# Endpoint testowy
@app.get("/")
def read_root():
    return {"message": "Hellooooo SOR"}

# 2. Główny endpoint do obliczania Triage
@app.post("/api/triage", response_model=TriageResponse)
def calculate_triage(patient_data: TriageRequest):
    # Sprawdzamy, czy model poprawnie wczytał się na starcie kontenera
    if modelAI is None:
        raise HTTPException(
            status_code=503, 
            detail="Model AI jest niedostępny (błąd konfiguracji pliku .pickle na serwerze)."
        )

    try:
        # Przygotowanie cech do predykcji
        features = [[
            patient_data.age, 
            patient_data.hr, 
            patient_data.sbp, 
            patient_data.dbp, 
            patient_data.pain_lvl
        ]]
        
        # Wykonanie predykcji
        prediction = modelAI.predict(features)
        
        # Konwersja wyniku na typ int
        result_priority = int(float(prediction[0]))
        
        return TriageResponse(priority_level=result_priority)
        
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Błąd wewnętrzny podczas przetwarzania przez model AI: {str(e)}"
        )