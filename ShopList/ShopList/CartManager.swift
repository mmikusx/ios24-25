//
//  CartManager.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//

import Foundation
import SwiftUI

class CartManager: ObservableObject {
    @Published var produktyWKoszyku: [Produkt: Int] = [:]

    func dodajDoKoszyka(_ produkt: Produkt, ilosc: Int) {
        guard ilosc > 0 else { return }
        if let obecnaIlosc = produktyWKoszyku[produkt] {
            produktyWKoszyku[produkt] = obecnaIlosc + ilosc
        } else {
            produktyWKoszyku[produkt] = ilosc
        }
    }

    func usunZKoszyka(_ produkt: Produkt) {
        produktyWKoszyku.removeValue(forKey: produkt)
    }

    func wyczyscKoszyk() {
        produktyWKoszyku.removeAll()
    }

    func suma() -> Double {
        produktyWKoszyku.reduce(0) { wynik, element in
            let cena = (element.key.cena as? NSDecimalNumber)?.doubleValue ?? 0.0
            return wynik + cena * Double(element.value)
        }
    }
}
