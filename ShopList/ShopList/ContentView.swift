//
//  ContentView.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // FetchRequest dla kategorii, produktów i zamówień
    @FetchRequest(
        entity: Kategoria.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Kategoria.nazwa, ascending: true)]
    ) private var kategorie: FetchedResults<Kategoria>

    @FetchRequest(
        entity: Produkt.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Produkt.nazwa, ascending: true)]
    ) private var produkty: FetchedResults<Produkt>

    @FetchRequest(
        entity: Zamowienie.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Zamowienie.data, ascending: false)]
    ) private var zamowienia: FetchedResults<Zamowienie>

    // Zmienna do przełączania zakładek
    @State private var wybranaZakladka = 0

    @State private var wybranaKategoria: Kategoria? = nil

    var body: some View {
        NavigationView {
            VStack {
                // Przełącznik zakładek
                Picker("Widok", selection: $wybranaZakladka) {
                    Text("Produkty").tag(0)
                    Text("Kategorie").tag(1)
                    Text("Zamówienia").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Widok produktów z podziałem na kategorie
                if wybranaZakladka == 0 {
                    List {
                        ForEach(kategorie) { kategoria in
                            Section(header: Text(kategoria.nazwa ?? "Brak nazwy")) {
                                let produktyKategorii = kategoria.produkty?.allObjects as? [Produkt] ?? []
                                ForEach(produktyKategorii) { produkt in
                                    ProduktRow(produkt: produkt)
                                }
                            }
                        }
                    }
                    .navigationTitle("Produkty")
                }

                else if wybranaZakladka == 1 {
                    if let wybranaKategoria {
                        // Lista produktów w wybranej kategorii
                        List {
                            let produktyKategorii = wybranaKategoria.produkty?.allObjects as? [Produkt] ?? []
                            ForEach(produktyKategorii) { produkt in
                                ProduktRow(produkt: produkt)
                            }
                        }
                        .navigationTitle(wybranaKategoria.nazwa ?? "Kategoria")
                        .toolbar {
                            Button("Wróć") {
                                resetujKategorie()
                            }
                        }

                    } else {
                        // Lista samych kategorii
                        List {
                            ForEach(kategorie) { kategoria in
                                Button(action: {
                                    wybranaKategoria = kategoria
                                }) {
                                    Text(kategoria.nazwa ?? "Brak nazwy")
                                        .font(.headline)
                                }
                            }
                        }
                        .navigationTitle("Kategorie")
                    }
                }



                // Widok zamówień
                else if wybranaZakladka == 2 {
                    List {
                        ForEach(zamowienia) { zamowienie in
                            Section(header: Text("Zamówienie dla \(zamowienie.klient ?? "Brak klienta")")) {
                                VStack(alignment: .leading) {
                                    Text("Adres: \(zamowienie.adres ?? "Brak adresu")")
                                    Text("Data: \(zamowienie.data ?? Date(), formatter: dateFormatter)")
                                    Text(String(format: "Suma: %.2f zł", obliczSume(zamowienie: zamowienie)))
                                        .font(.footnote)
                                        .foregroundColor(.blue)
                                }

                                // Produkty w zamówieniu
                                let produkty = zamowienie.produkty?.allObjects as? [Produkt] ?? []
                                ForEach(produkty) { produkt in
                                    ProduktRow(produkt: produkt)
                                }
                            }
                        }
                    }
                    .navigationTitle("Zamówienia")
                }
            }
            .onAppear {
                // Pobieranie danych z API
                NetworkManager.shared.fetchKategorie {}
                NetworkManager.shared.fetchProdukty {}
                NetworkManager.shared.fetchZamowienia {}
            }
        }
    }

    // Funkcja do obliczania sumy zamówienia
    private func obliczSume(zamowienie: Zamowienie) -> Double {
        let produkty = zamowienie.produkty?.allObjects as? [Produkt] ?? []
        return produkty.reduce(0.0) { $0 + (($1.cena as? NSDecimalNumber)?.doubleValue ?? 0.0) }
    }
    
    func resetujKategorie() {
        wybranaKategoria = nil
    }

}

// Komponent do wyświetlania produktu
struct ProduktRow: View {
    var produkt: Produkt

    var body: some View {
        VStack(alignment: .leading) {
            Text(produkt.nazwa ?? "Brak nazwy")
                .font(.headline)
            Text(produkt.opis ?? "Brak opisu")
                .font(.subheadline)
            Text(String(format: "%.2f zł", (produkt.cena as? NSDecimalNumber)?.doubleValue ?? 0.0))
                .font(.footnote)
                .foregroundColor(.green)
        }
        .padding(.vertical, 5)
    }
}

// Formatowanie daty
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    ContentView()
}
