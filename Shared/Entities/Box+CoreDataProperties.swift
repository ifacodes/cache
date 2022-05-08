//
//  Box+CoreDataProperties.swift
//  cache
//
//  Created by Aoife Bradley on 2022-02-25.
//
//

import Foundation
import CoreData


extension Box {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Box> {
        return NSFetchRequest<Box>(entityName: "Box")
    }

    @NSManaged public var name: String
    @NSManaged public var timestamp: Date?
    @NSManaged public var items: Set<Item>
    @NSManaged public var uuid: UUID

}

// MARK: Generated accessors for items
extension Box {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Box : Identifiable {
}

extension Box: Comparable {
    
    static public func <(lhs: Box, rhs: Box) -> Bool {
        (lhs.name) < (rhs.name)
    }
    static public func ==(lhs: Box, rhs: Box) -> Bool {
        (lhs.name) == (rhs.name)
    }
    static public func >(lhs: Box, rhs: Box) -> Bool {
        (lhs.name) > (rhs.name)
    }

}

extension Box {
    
    ///  add alphabetical box name
    ///  this is an optional feature enabled in settings
    static func nextBoxName(cache: Cache) -> String {
        
        func inc(_ name: String) -> String {
            if name == "Z" {
                return "AA"
            }
            var tail = String(name.last!)
            var rest = String(name.dropLast())
            if tail == "Z" {
                tail = "A"
                rest = inc(rest)
            } else {
                let tailScalarValue = tail.unicodeScalars.last!.value
                tail = String(UnicodeScalar(tailScalarValue+1)!)
            }
            return rest + tail
        }
        
        if cache.boxes.isEmpty {
            return "A"
        } else {
            let lastName = cache.boxes.sorted{$0.name < $1.name}.last!.name
            return inc(lastName)
        }
    }
}


