//
//  NetworkManager.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//
import Foundation
import CoreData

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "http://127.0.0.1:8000"

    func fetchKategorie(completion: @escaping () -> Void) {
        guard let url = URL(string: "\(baseURL)/kategorie") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let kategorieAPI = try JSONDecoder().decode([KategoriaAPI].self, from: data)
                    DispatchQueue.main.async {
                        self.saveKategorieToCoreData(kategorieAPI)
                        completion()
                    }
                } catch {
                    print("Błąd dekodowania kategorii: \(error)")
                }
            }
        }.resume()
    }

    func saveKategorieToCoreData(_ kategorieAPI: [KategoriaAPI]) {
        let context = PersistenceController.shared.container.viewContext

        for kategoriaAPI in kategorieAPI {
            let fetchRequest: NSFetchRequest<Kategoria> = Kategoria.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", kategoriaAPI.id)

            if let existingCategory = try? context.fetch(fetchRequest).first {
                existingCategory.nazwa = kategoriaAPI.nazwa
            } else {
                let nowaKategoria = Kategoria(context: context)
                nowaKategoria.id = UUID(uuidString: kategoriaAPI.id)
                nowaKategoria.nazwa = kategoriaAPI.nazwa
            }
        }

        do {
            try context.save()
            print("Kategorie zapisane do Core Data")
        } catch {
            print("Błąd zapisu kategorii: \(error)")
        }
    }

    func fetchProdukty(completion: @escaping () -> Void) {
        guard let url = URL(string: "\(baseURL)/produkty") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let produktyAPI = try JSONDecoder().decode([ProduktAPI].self, from: data)
                    DispatchQueue.main.async {
                        self.saveProduktyToCoreData(produktyAPI)
                        completion()
                    }
                } catch {
                    print("Błąd dekodowania produktów: \(error)")
                }
            }
        }.resume()
    }

    func saveProduktyToCoreData(_ produktyAPI: [ProduktAPI]) {
        let context = PersistenceController.shared.container.viewContext

        for produktAPI in produktyAPI {
            let fetchRequest: NSFetchRequest<Produkt> = Produkt.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", produktAPI.id)

            if let existingProduct = try? context.fetch(fetchRequest).first {
                existingProduct.nazwa = produktAPI.nazwa
                existingProduct.cena = NSDecimalNumber(value: produktAPI.cena)
                existingProduct.opis = produktAPI.opis
            } else {
                let nowyProdukt = Produkt(context: context)
                nowyProdukt.id = UUID(uuidString: produktAPI.id)
                nowyProdukt.nazwa = produktAPI.nazwa
                nowyProdukt.cena = NSDecimalNumber(value: produktAPI.cena)
                nowyProdukt.opis = produktAPI.opis

                if produktAPI.opis.lowercased().contains("owoc") {
                    let kategoriaFetchRequest: NSFetchRequest<Kategoria> = Kategoria.fetchRequest()
                    kategoriaFetchRequest.predicate = NSPredicate(format: "nazwa == %@", "Owoce z API")
                    if let kategoria = try? context.fetch(kategoriaFetchRequest).first {
                        nowyProdukt.kategoria = kategoria
                    }
                } else if produktAPI.opis.lowercased().contains("napój") {
                    let kategoriaFetchRequest: NSFetchRequest<Kategoria> = Kategoria.fetchRequest()
                    kategoriaFetchRequest.predicate = NSPredicate(format: "nazwa == %@", "Napoje z API")
                    if let kategoria = try? context.fetch(kategoriaFetchRequest).first {
                        nowyProdukt.kategoria = kategoria
                    }
                } else if produktAPI.opis.lowercased().contains("słodycz") {
                    let kategoriaFetchRequest: NSFetchRequest<Kategoria> = Kategoria.fetchRequest()
                    kategoriaFetchRequest.predicate = NSPredicate(format: "nazwa == %@", "Słodycze z API")
                    if let kategoria = try? context.fetch(kategoriaFetchRequest).first {
                        nowyProdukt.kategoria = kategoria
                    }
                }
            }
        }

        do {
            try context.save()
            print("Produkty zapisane do Core Data")
        } catch {
            print("Błąd zapisu produktów: \(error)")
        }
    }
    
    func fetchZamowienia(completion: @escaping () -> Void) {
        guard let url = URL(string: "http://localhost:8000/zamowienia") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Błąd pobierania zamówień: \(error)")
                completion()
                return
            }

            guard let data = data else {
                print("Brak danych dla zamówień")
                completion()
                return
            }

            do {
                let zamowieniaAPI = try JSONDecoder().decode([ZamowienieAPI].self, from: data)
                DispatchQueue.main.async {
                    self.saveZamowieniaToCoreData(zamowieniaAPI)
                    completion()
                }
            } catch {
                print("Błąd dekodowania zamówień: \(error)")
                completion()
            }
        }.resume()
    }

    
    func saveZamowieniaToCoreData(_ zamowieniaAPI: [ZamowienieAPI]) {
        let context = PersistenceController.shared.container.viewContext

        for zamowienieAPI in zamowieniaAPI {
            let fetchRequest: NSFetchRequest<Zamowienie> = Zamowienie.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", zamowienieAPI.id)

            if let existingOrder = try? context.fetch(fetchRequest).first {
                existingOrder.data = ISO8601DateFormatter().date(from: zamowienieAPI.data) ?? Date()
                existingOrder.klient = zamowienieAPI.klient
                existingOrder.adres = zamowienieAPI.adres
                existingOrder.suma = NSDecimalNumber(value: zamowienieAPI.suma)
            } else {
                let noweZamowienie = Zamowienie(context: context)
                noweZamowienie.id = UUID(uuidString: zamowienieAPI.id)
                noweZamowienie.data = ISO8601DateFormatter().date(from: zamowienieAPI.data) ?? Date()
                noweZamowienie.klient = zamowienieAPI.klient
                noweZamowienie.adres = zamowienieAPI.adres
                noweZamowienie.suma = NSDecimalNumber(value: zamowienieAPI.suma)

                var produktyDoDodania: [Produkt] = []
                for produktAPI in zamowienieAPI.produkty {
                    let fetchProduct: NSFetchRequest<Produkt> = Produkt.fetchRequest()
                    fetchProduct.predicate = NSPredicate(format: "id == %@", produktAPI.id)

                    if let produkt = try? context.fetch(fetchProduct).first {
                        produktyDoDodania.append(produkt) // Dodajemy produkt do listy
                    }
                }

                // Dodanie całej listy produktów do zamówienia
                noweZamowienie.addToProdukty(NSSet(array: produktyDoDodania))

            }
        }

        do {
            try context.save()
            print("Zamówienia zapisane do Core Data")
        } catch {
            print("Błąd zapisu zamówień: \(error)")
        }
    }


}
