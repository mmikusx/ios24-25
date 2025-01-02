//
//  Persistence.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        let kategoria1 = Kategoria(context: context)
        kategoria1.id = UUID()
        kategoria1.nazwa = "Owoce"

        let kategoria2 = Kategoria(context: context)
        kategoria2.id = UUID()
        kategoria2.nazwa = "Napoje"

        let produkt1 = Produkt(context: context)
        produkt1.id = UUID()
        produkt1.nazwa = "Jabłko"
        produkt1.cena = 2.50
        produkt1.opis = "Świeże jabłka z sadu."
        produkt1.kategoria = kategoria1

        let produkt2 = Produkt(context: context)
        produkt2.id = UUID()
        produkt2.nazwa = "Sok pomarańczowy"
        produkt2.cena = 5.99
        produkt2.opis = "Naturalny sok bez dodatków."
        produkt2.kategoria = kategoria2

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ShopList")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        if !inMemory {
            loadFixtures()
        }
    }

    func loadFixtures() {
        let context = container.viewContext

        let fetchRequest: NSFetchRequest<Kategoria> = Kategoria.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                return
            }
        } catch {
            print("Błąd podczas sprawdzania danych początkowych: \(error)")
        }

        let kategoria1 = Kategoria(context: context)
        kategoria1.id = UUID()
        kategoria1.nazwa = "Owoce"

        let kategoria2 = Kategoria(context: context)
        kategoria2.id = UUID()
        kategoria2.nazwa = "Napoje"

        let produkt1 = Produkt(context: context)
        produkt1.id = UUID()
        produkt1.nazwa = "Jabłko"
        produkt1.cena = 2.50
        produkt1.opis = "Świeże jabłka z sadu."
        produkt1.kategoria = kategoria1

        let produkt2 = Produkt(context: context)
        produkt2.id = UUID()
        produkt2.nazwa = "Sok pomarańczowy"
        produkt2.cena = 5.99
        produkt2.opis = "Naturalny sok bez dodatków."
        produkt2.kategoria = kategoria2

        do {
            try context.save()
            print("Dane testowe zostały załadowane!")
        } catch {
            print("Błąd podczas zapisywania danych: \(error)")
        }
    }
}
