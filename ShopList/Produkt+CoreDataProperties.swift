//
//  Produkt+CoreDataProperties.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//
//

import Foundation
import CoreData


extension Produkt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Produkt> {
        return NSFetchRequest<Produkt>(entityName: "Produkt")
    }

    @NSManaged public var nazwa: String?
    @NSManaged public var cena: NSDecimalNumber?
    @NSManaged public var id: UUID?
    @NSManaged public var kategoria: Kategoria?

}

extension Produkt : Identifiable {

}
