//
//  Kategoria+CoreDataProperties.swift
//  ShopList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//
//

import Foundation
import CoreData


extension Kategoria {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kategoria> {
        return NSFetchRequest<Kategoria>(entityName: "Kategoria")
    }

    @NSManaged public var nazwa: String?
    @NSManaged public var id: UUID?
    @NSManaged public var produkty: NSSet?

}

// MARK: Generated accessors for produkty
extension Kategoria {

    @objc(addProduktyObject:)
    @NSManaged public func addToProdukty(_ value: Produkt)

    @objc(removeProduktyObject:)
    @NSManaged public func removeFromProdukty(_ value: Produkt)

    @objc(addProdukty:)
    @NSManaged public func addToProdukty(_ values: NSSet)

    @objc(removeProdukty:)
    @NSManaged public func removeFromProdukty(_ values: NSSet)

}

extension Kategoria : Identifiable {

}
