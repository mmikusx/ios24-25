//
//  Models.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//


import Foundation

struct ProduktAPI: Codable, Identifiable {
    var id: String
    var nazwa: String
    var cena: Double
    var opis: String
    var kategoria_id: String
}

struct KategoriaAPI: Codable, Identifiable {
    var id: String
    var nazwa: String
}
