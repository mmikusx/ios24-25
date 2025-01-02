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
        entity: Zamowienie.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Zamowienie.data, ascending: false)]
    ) private var zamowienia: FetchedResults<Zamowienie>

    var body: some View {
        NavigationView {
            List {
                ForEach(kategorie) { kategoria in
                    Section(header: Text(kategoria.nazwa ?? "Brak nazwy")) {
                        let produkty = kategoria.produkty?.allObjects as? [Produkt] ?? []
                        ForEach(produkty) { produkt in
                            VStack(alignment: .leading) {
                                Text(produkt.nazwa ?? "Brak nazwy")
                                    .font(.headline)
                                Text(produkt.opis ?? "Brak opisu")
                                    .font(.subheadline)
                                Text(String(format: "%.2f zł", (produkt.cena as? NSDecimalNumber)?.doubleValue ?? 0.0))
                                    .font(.footnote)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }

                Section(header: Text("Zamówienia")) {
                    ForEach(zamowienia) { zamowienie in
                        VStack(alignment: .leading) {
                            Text("Klient: \(zamowienie.klient ?? "Brak klienta")")
                                .font(.headline)

                            Text("Adres: \(zamowienie.adres ?? "Brak adresu")")
                                .font(.subheadline)

                            Text(String(format: "Suma: %.2f zł", (zamowienie.suma as? NSDecimalNumber)?.doubleValue ?? 0.0))
                                .font(.footnote)
                                .foregroundColor(.blue)

                            Text("Data: \(zamowienie.data ?? Date(), formatter: dateFormatter)")
                                .font(.footnote)
                                .foregroundColor(.gray)

                            let produkty = zamowienie.produkty?.allObjects as? [Produkt] ?? []
                            ForEach(produkty) { produkt in
                                Text("- \(produkt.nazwa ?? "Brak nazwy")")
                                    .font(.footnote)
                                    .padding(.leading, 10)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Produkty i Zamówienia")
            .onAppear {
                NetworkManager.shared.fetchKategorie {}
                NetworkManager.shared.fetchProdukty {}
                NetworkManager.shared.fetchZamowienia {}
            }
        }
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
