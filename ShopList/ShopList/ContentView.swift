//
//  ContentView.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var cartManager = CartManager()

    var body: some View {
        TabView {
            ProductListView()
                .tabItem {
                    Label("Produkty", systemImage: "list.bullet")
                }
                .environmentObject(cartManager)

            CartView()
                .tabItem {
                    Label("Koszyk", systemImage: "cart")
                }
                .environmentObject(cartManager)
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
