from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
from uuid import uuid4

app = FastAPI()

class Produkt(BaseModel):
    id: str
    nazwa: str
    cena: float
    opis: str
    kategoria_id: str

class Kategoria(BaseModel):
    id: str
    nazwa: str

class Zamowienie(BaseModel):
    id: str
    produkty: List[str]
    data: str
    klient: str
    status: str

# DANE TESTOWE
kategorie = [
    Kategoria(id=str(uuid4()), nazwa="Owoce z API"),
    Kategoria(id=str(uuid4()), nazwa="Napoje z API"),
    Kategoria(id=str(uuid4()), nazwa="Słodycze z API")
]

produkty = [
    Produkt(id=str(uuid4()), nazwa="Jabłko z API", cena=2.50, opis="Świeże jabłka z sadu.", kategoria_id=kategorie[0].id),
    Produkt(id=str(uuid4()), nazwa="Banany z API", cena=4.20, opis="Dojrzałe banany importowane.", kategoria_id=kategorie[0].id),
    Produkt(id=str(uuid4()), nazwa="Gruszka z API", cena=3.80, opis="Gruszki z lokalnych upraw.", kategoria_id=kategorie[0].id),

    Produkt(id=str(uuid4()), nazwa="Sok pomarańczowy z API", cena=5.99, opis="Naturalny sok bez dodatków.", kategoria_id=kategorie[1].id),
    Produkt(id=str(uuid4()), nazwa="Woda mineralna z API", cena=1.99, opis="Niegazowana woda mineralna.", kategoria_id=kategorie[1].id),
    Produkt(id=str(uuid4()), nazwa="Cola z API", cena=3.50, opis="Orzeźwiający napój gazowany.", kategoria_id=kategorie[1].id),

    Produkt(id=str(uuid4()), nazwa="Czekolada mleczna z API", cena=4.99, opis="Delikatna mleczna czekolada.", kategoria_id=kategorie[2].id),
    Produkt(id=str(uuid4()), nazwa="Żelki owocowe z API", cena=6.50, opis="Kolorowe żelki o smaku owocowym.", kategoria_id=kategorie[2].id),
    Produkt(id=str(uuid4()), nazwa="Baton czekoladowy z API", cena=2.80, opis="Baton z nadzieniem karmelowym.", kategoria_id=kategorie[2].id)
]

zamowienia = [
    Zamowienie(id=str(uuid4()), produkty=[produkty[0].id, produkty[3].id], data="2025-01-02", klient="Jan Kowalski", status="Wysłano"),
    Zamowienie(id=str(uuid4()), produkty=[produkty[2].id, produkty[5].id], data="2025-01-03", klient="Anna Nowak", status="W trakcie realizacji"),
    Zamowienie(id=str(uuid4()), produkty=[produkty[1].id], data="2025-01-04", klient="Michał Wiśniewski", status="Dostarczono")
]

# ENDPOINTY
@app.get("/kategorie", response_model=List[Kategoria])
def get_kategorie():
    return kategorie

@app.get("/produkty", response_model=List[Produkt])
def get_produkty():
    return produkty

@app.post("/produkty", response_model=Produkt)
def add_produkt(produkt: Produkt):
    produkt.id = str(uuid4())
    produkty.append(produkt)
    return produkt

@app.get("/zamowienia", response_model=List[Zamowienie])
def get_zamowienia():
    return zamowienia
