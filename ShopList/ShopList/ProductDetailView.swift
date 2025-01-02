//
//  ProductDetailView.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//

import SwiftUI

struct ProductDetailView: View {
    var produkt: Produkt
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode

    @State private var ilosc: Int = 1

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

            Stepper(value: $ilosc, in: 1...10) {
                Text("Ilość: \(ilosc)")
            }
            .padding()

            Spacer()

            Button(action: {
                cartManager.dodajDoKoszyka(produkt, ilosc: ilosc)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Dodaj do koszyka")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle(produkt.nazwa ?? "Produkt")
    }
}
