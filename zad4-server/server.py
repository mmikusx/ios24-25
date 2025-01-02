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


class Kategoria(BaseModel):
    id: str
    nazwa: str


class Zamowienie(BaseModel):
    id: str
    data: str
    klient: str
    adres: str
    produkty: List[Produkt]

    def oblicz_sume(self) -> float:
        return sum(produkt.cena for produkt in self.produkty)


# Przykładowe dane
kategorie = [
    Kategoria(id=str(uuid4()), nazwa="Owoce z API"),
    Kategoria(id=str(uuid4()), nazwa="Napoje z API"),
    Kategoria(id=str(uuid4()), nazwa="Słodycze z API")
]

produkty = [
    Produkt(id=str(uuid4()), nazwa="Jabłko z API", cena=2.50, opis="Owoc. Świeże jabłka z sadu."),
    Produkt(id=str(uuid4()), nazwa="Banany z API", cena=4.20, opis="Owoc. Dojrzałe banany importowane."),
    Produkt(id=str(uuid4()), nazwa="Gruszka z API", cena=3.80, opis="Owoc. Gruszki z lokalnych upraw."),

    Produkt(id=str(uuid4()), nazwa="Sok pomarańczowy z API", cena=5.99, opis="Napój. Naturalny sok bez dodatków."),
    Produkt(id=str(uuid4()), nazwa="Woda mineralna z API", cena=1.99, opis="Napój. Niegazowana woda mineralna."),
    Produkt(id=str(uuid4()), nazwa="Cola z API", cena=3.50, opis="Orzeźwiający napój gazowany."),

    Produkt(id=str(uuid4()), nazwa="Czekolada mleczna z API", cena=4.99, opis="Słodycze. Delikatna mleczna czekolada."),
    Produkt(id=str(uuid4()), nazwa="Żelki owocowe z API", cena=6.50, opis="Słodycze. Kolorowe żelki o smaku owocowym."),
    Produkt(id=str(uuid4()), nazwa="Baton czekoladowy z API", cena=2.80, opis="Słodycze. Baton z nadzieniem karmelowym.")
]

zamowienia = [
    Zamowienie(
        id=str(uuid4()),
        data="2025-01-02",
        klient="Jan Kowalski",
        adres="ul. Kwiatowa 15, Kraków",
        produkty=[produkty[0], produkty[1], produkty[4]]
    ),
    Zamowienie(
        id=str(uuid4()),
        data="2025-01-03",
        klient="Anna Nowak",
        adres="ul. Słoneczna 22, Warszawa",
        produkty=[produkty[2], produkty[5], produkty[6], produkty[7]]
    )
]


@app.get("/kategorie", response_model=List[Kategoria])
def get_kategorie():
    return kategorie


@app.get("/produkty", response_model=List[Produkt])
def get_produkty():
    return produkty


@app.get("/zamowienia")
def get_zamowienia():
    return [
        {
            "id": zamowienie.id,
            "data": zamowienie.data,
            "klient": zamowienie.klient,
            "adres": zamowienie.adres,
            "suma": zamowienie.oblicz_sume(),
            "produkty": zamowienie.produkty
        }
        for zamowienie in zamowienia
    ]
