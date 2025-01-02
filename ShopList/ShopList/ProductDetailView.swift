//
//  ProductDetailView.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//

import SwiftUI

struct ProductDetailView: View {
    var produkt: Produkt

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(produkt.nazwa ?? "Nieznany produkt")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(produkt.opis ?? "Brak opisu")
                .font(.body)

            Text(String(format: "Cena: %.2f zł", (produkt.cena as? NSDecimalNumber)?.doubleValue ?? 0.0))
                .font(.headline)
                .foregroundColor(.green)

            Spacer()
        }
        .padding()
        .navigationTitle(produkt.nazwa ?? "Produkt")
    }
}
