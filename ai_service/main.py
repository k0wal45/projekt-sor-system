from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

app = FastAPI()

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
    return {"messege": "Hello SOR"}

# 2. Główny endpoint do obliczania Triage
@app.post("/api/triage", response_model=TriageResponse)
def calculate_triage(patient_data: TriageRequest):
    try:
        # --- MIEJSCE NA MODEL AI ---
        # features = [[patient_data.age, patient_data.hr, ...]]
        # prediction = AI_model.predict(features)
        
        # Tymczasowa, przejrzysta logika algorytmu Triage (jako silnik regułowy):
        priority_level = 4

        # Skrajne tętno -> (Natychmiastowa pomoc)
        if  patient_data.hr > 140:
            priority_level = 1
            
        # Bardzo niska saturacja ale stabilne tętno -> (Bardzo pilny)
        elif 90 <= patient_data.age and  patient_data.sbp > 200:
            priority_level = 2

        # Silny ból lub wysokie ciśnienie -> (Pilny)
        elif patient_data.pain_lvl >= 8 or patient_data.sbp > 180:
            priority_level = 3


        return TriageResponse(priority_level=priority_level)
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Błąd wewnętrzny modelu AI: {str(e)}")