//
//  NetworkManager.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "http://127.0.0.1:8000"

    func fetchKategorie(completion: @escaping ([KategoriaAPI]) -> Void) {
        guard let url = URL(string: "\(baseURL)/kategorie") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let kategorie = try JSONDecoder().decode([KategoriaAPI].self, from: data)
                    DispatchQueue.main.async {
                        completion(kategorie)
                    }
                } catch {
                    print("Błąd dekodowania kategorii: \(error)")
                }
            }
        }.resume()
    }

    func fetchProdukty(completion: @escaping ([ProduktAPI]) -> Void) {
        guard let url = URL(string: "\(baseURL)/produkty") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let produkty = try JSONDecoder().decode([ProduktAPI].self, from: data)
                    DispatchQueue.main.async {
                        completion(produkty)
                    }
                } catch {
                    print("Błąd dekodowania produktów: \(error)")
                }
            }
        }.resume()
    }
}
