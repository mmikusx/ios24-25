//
//  ProdutListView.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//

import SwiftUI
import CoreData

struct ProductListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Produkt.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Produkt.nazwa, ascending: true)]
    ) var produkty: FetchedResults<Produkt>

    var body: some View {
        NavigationView {
            List {
                ForEach(produkty) { produkt in
                    NavigationLink(destination: ProductDetailView(produkt: produkt)) {
                        VStack(alignment: .leading) {
                            Text(produkt.nazwa ?? "Nieznany produkt")
                                .font(.headline)
                            Text(String(format: "%.2f zł", (produkt.cena as? NSDecimalNumber)?.doubleValue ?? 0.0))
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Produkty")
        }
    }
}
