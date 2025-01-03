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

    @State private var wybranaZakladka = 0

    @State private var wybranaKategoria: Kategoria? = nil

    @State private var pokazFormularzDodawania = false

    var body: some View {
        NavigationView {
            VStack {
                Picker("Widok", selection: $wybranaZakladka) {
                    Text("Produkty").tag(0)
                    Text("Kategorie").tag(1)
                    Text("Zamówienia").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

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
                    .navigationBarItems(trailing:
                        Button(action: {
                            pokazFormularzDodawania = true
                        }) {
                            Label("Dodaj Produkt", systemImage: "plus")
                        }
                    )
                }

                else if wybranaZakladka == 1 {
                    if let wybranaKategoria {
                        List {
                            let produktyKategorii = wybranaKategoria.produkty?.allObjects as? [Produkt] ?? []
                            ForEach(produktyKategorii) { produkt in
                                ProduktRow(produkt: produkt)
                            }
                        }
                        .navigationTitle(wybranaKategoria.nazwa ?? "Kategoria")
                        .navigationBarItems(leading:
                            Button("Wróć") {
                            resetujKategorie()
                            }
                        )
                    } else {
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
                NetworkManager.shared.fetchKategorie {}
                NetworkManager.shared.fetchProdukty {}
                NetworkManager.shared.fetchZamowienia {}
            }
            .sheet(isPresented: $pokazFormularzDodawania) {
                FormularzDodawaniaProduktu(context: viewContext, kategorie: kategorie)
            }
        }
    }

    private func obliczSume(zamowienie: Zamowienie) -> Double {
        let produkty = zamowienie.produkty?.allObjects as? [Produkt] ?? []
        return produkty.reduce(0.0) { $0 + (($1.cena as? NSDecimalNumber)?.doubleValue ?? 0.0) }
    }
    
    private func resetujKategorie() {
        wybranaKategoria = nil
    }

}

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

struct FormularzDodawaniaProduktu: View {
    @Environment(\.presentationMode) var presentationMode
    var context: NSManagedObjectContext
    var kategorie: FetchedResults<Kategoria>

    @State private var nazwa = ""
    @State private var cena = ""
    @State private var opis = ""
    @State private var wybranaKategoria: Kategoria?

    var body: some View {
        NavigationView {
            Form {
                TextField("Nazwa produktu", text: $nazwa)
                TextField("Cena", text: $cena)
                    .keyboardType(.decimalPad)
                TextField("Opis", text: $opis)

                Picker("Kategoria", selection: $wybranaKategoria) {
                    ForEach(kategorie) { kategoria in
                        Text(kategoria.nazwa ?? "").tag(kategoria as Kategoria?)
                    }
                }

                Button("Dodaj Produkt") {
                    let nowyProdukt = Produkt(context: context)
                    nowyProdukt.id = UUID()
                    nowyProdukt.nazwa = nazwa
                    nowyProdukt.opis = opis
                    nowyProdukt.cena = NSDecimalNumber(string: cena)
                    nowyProdukt.kategoria = wybranaKategoria

                    try? context.save()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Nowy Produkt")
            .toolbar {
                Button("Anuluj") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
