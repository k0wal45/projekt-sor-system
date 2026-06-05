Schemat bazy danych:
1. Pacjent (Patients)
id (PK)
imie, nazwisko, pesel, data_urodzenia, plec (Enum: M/K/INNY)
adres (raczej jako jeden ciąg znaków, np. "ul. Długa 5, 44-200 Rybnik")
telefon, email
kontakt_awaryjny_dane (imię i nazwisko osoby), kontakt_awaryjny_telefon
grupa_krwi (Enum)
uczulenia, choroby_przewlekle (wykłe pole tekstowe).
2. Personel (Staff) - Konta dla lekarzy, ratowników i recepcji.
id (PK)
imie, nazwisko, tytul_naukowy
rola (Enum: PIELEGNIARZ, RATOWNIK, LEKARZ, ADMIN)
[dane_logowania] login_email (albo sam login wygenerowany), password_hash.
3. Przyjęcie na SOR (Admissions)
id (PK)
id_pacjenta (FK -> Patients)
id_osoby_przyjmujacej (FK -> Staff - ratownik/pielegniarz, który robił Triage)
id_lekarza_prowadzacego (FK -> Staff - Domyślnie NULL. Gdy lekarz "pobierze" pacjenta z kolejki na swoim ekranie, wpisuje się tu jego ID).
data_przyjecia (Timestamp)
forma_przybycia, uraz/y (chyba tekst), mental_status, pain_lvl
hr, sbp, dbp, rr, bt (Wartości numeryczne)
chief_complaint (tekst)
priority_ktas (1-5)
is_ai_predicted (Boolean - czy priorytet nadało AI, czy człowiek)
status_przyjecia (Enum: W_POCZEKALNI, W_GABINECIE, OCZEKUJE_NA_WYNIKI, ZAKONCZONE).
4. Konsultacja Lekarska (Consultations) - cyfrowa karta wypełniana w gabinecie
id (PK)
id_przyjecia (FK -> Admissions)
wywiad_medyczny (pole tekstowe dla lekarza)
diagnoza Tekst)
decyzja_wypisowa (Enum: DO_DOMU, NA_ODDZIAL, OIOM, ZGON)
data_zakonczenia (Timestamp)
5. Zlecenia Diagnostyczne (Diagnostic_Orders) - dodatkowe badania, które lekarz zleca, żeby zmienić status na "Oczekuje na wyniki" [przyjecia]).
id (PK)
id_przyjecia (FK -> Admissions)
typ_zlecenia (Enum: KREW, RTG, TK, USG, EKG, INNE)
uwagi_zlecenia (Tekst)
status_zlecenia (Enum: ZLECONE, W_TRAKCIE, WYNIK_GOTOWY)