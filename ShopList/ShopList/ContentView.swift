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
            }
            .navigationTitle("Produkty i Kategorie")
            .onAppear {
                NetworkManager.shared.fetchKategorie {}
                NetworkManager.shared.fetchProdukty {}
            }
        }
    }
}


#Preview {
    ContentView()
}
