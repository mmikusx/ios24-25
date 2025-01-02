//
//  CartView.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        VStack {
            if cartManager.produktyWKoszyku.isEmpty {
                Text("Koszyk jest pusty")
                    .font(.headline)
            } else {
                List {
                    ForEach(cartManager.produktyWKoszyku.keys.sorted(by: { $0.nazwa ?? "" < $1.nazwa ?? "" }), id: \.self) { produkt in
                        let ilosc = cartManager.produktyWKoszyku[produkt] ?? 0
                        HStack {
                            Text(produkt.nazwa ?? "Nieznany produkt")
                            Spacer()
                            Text("\(ilosc) x")
                            Text(String(format: "%.2f zł", (produkt.cena as? NSDecimalNumber)?.doubleValue ?? 0.0))
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let produkt = Array(cartManager.produktyWKoszyku.keys)[index]
                            cartManager.usunZKoszyka(produkt)
                        }
                    }
                }

                Text(String(format: "Suma: %.2f zł", cartManager.suma()))
                    .font(.headline)
                    .padding()
            }
        }
        .navigationTitle("Koszyk")
        .toolbar {
            Button("Wyczyść koszyk") {
                cartManager.wyczyscKoszyk()
            }
        }
    }
}
