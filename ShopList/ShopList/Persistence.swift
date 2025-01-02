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
//        if !inMemory {
//            loadFixtures()
//        }
    }

//    func loadFixtures() {
//        let context = container.viewContext
//
//        let fetchRequest: NSFetchRequest<Kategoria> = Kategoria.fetchRequest()
//        do {
//            let count = try context.count(for: fetchRequest)
//            if count > 0 {
//                return
//            }
//        } catch {
//            print("Błąd podczas sprawdzania danych początkowych: \(error)")
//        }
//
//        let kategoria1 = Kategoria(context: context)
//        kategoria1.id = UUID()
//        kategoria1.nazwa = "Owoce"
//
//        let kategoria2 = Kategoria(context: context)
//        kategoria2.id = UUID()
//        kategoria2.nazwa = "Napoje"
//
//        let kategoria3 = Kategoria(context: context)
//        kategoria3.id = UUID()
//        kategoria3.nazwa = "Słodycze"
//
//        let produkt1 = Produkt(context: context)
//        produkt1.id = UUID()
//        produkt1.nazwa = "Jabłko"
//        produkt1.cena = 2.50
//        produkt1.opis = "Świeże jabłka z sadu."
//        produkt1.kategoria = kategoria1
//
//        let produkt2 = Produkt(context: context)
//        produkt2.id = UUID()
//        produkt2.nazwa = "Banany"
//        produkt2.cena = 4.20
//        produkt2.opis = "Dojrzałe banany importowane."
//        produkt2.kategoria = kategoria1
//
//        let produkt3 = Produkt(context: context)
//        produkt3.id = UUID()
//        produkt3.nazwa = "Gruszka"
//        produkt3.cena = 3.80
//        produkt3.opis = "Gruszki z lokalnych upraw."
//        produkt3.kategoria = kategoria1
//
//        let produkt4 = Produkt(context: context)
//        produkt4.id = UUID()
//        produkt4.nazwa = "Sok pomarańczowy"
//        produkt4.cena = 5.99
//        produkt4.opis = "Naturalny sok bez dodatków."
//        produkt4.kategoria = kategoria2
//
//        let produkt5 = Produkt(context: context)
//        produkt5.id = UUID()
//        produkt5.nazwa = "Woda mineralna"
//        produkt5.cena = 1.99
//        produkt5.opis = "Niegazowana woda mineralna."
//        produkt5.kategoria = kategoria2
//
//        let produkt6 = Produkt(context: context)
//        produkt6.id = UUID()
//        produkt6.nazwa = "Cola"
//        produkt6.cena = 3.50
//        produkt6.opis = "Orzeźwiający napój gazowany."
//        produkt6.kategoria = kategoria2
//
//        let produkt7 = Produkt(context: context)
//        produkt7.id = UUID()
//        produkt7.nazwa = "Czekolada mleczna"
//        produkt7.cena = 4.99
//        produkt7.opis = "Delikatna mleczna czekolada."
//        produkt7.kategoria = kategoria3
//
//        let produkt8 = Produkt(context: context)
//        produkt8.id = UUID()
//        produkt8.nazwa = "Żelki owocowe"
//        produkt8.cena = 6.50
//        produkt8.opis = "Kolorowe żelki o smaku owocowym."
//        produkt8.kategoria = kategoria3
//
//        let produkt9 = Produkt(context: context)
//        produkt9.id = UUID()
//        produkt9.nazwa = "Baton czekoladowy"
//        produkt9.cena = 2.80
//        produkt9.opis = "Baton z nadzieniem karmelowym."
//        produkt9.kategoria = kategoria3
//
//        do {
//            try context.save()
//            print("Dane testowe zostały zapisane!")
//        } catch {
//            print("Błąd podczas zapisywania danych: \(error)")
//        }
//    }

}
