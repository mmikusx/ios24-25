//
//  ContentView.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var produkty: [ProduktAPI] = []
    @State private var kategorie: [KategoriaAPI] = []

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Kategorie")) {
                    ForEach(kategorie) { kategoria in
                        Text(kategoria.nazwa)
                    }
                }

                Section(header: Text("Produkty")) {
                    ForEach(produkty) { produkt in
                        VStack(alignment: .leading) {
                            Text(produkt.nazwa)
                                .font(.headline)
                            Text(produkt.opis)
                                .font(.subheadline)
                            Text(String(format: "%.2f zł", produkt.cena))
                                .font(.footnote)
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationTitle("Dane z serwera")
            .onAppear {
                NetworkManager.shared.fetchKategorie { dane in
                    kategorie = dane
                }
                NetworkManager.shared.fetchProdukty { dane in
                    produkty = dane
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
