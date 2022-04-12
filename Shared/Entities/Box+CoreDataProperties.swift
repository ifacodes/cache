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

    @NSManaged public var status: Int64
    @NSManaged public var name: String
    @NSManaged public var timestamp: Date?
    @NSManaged public var items: NSSet?
    @NSManaged public var uuid: UUID
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID(), forKey: (\Box.uuid)._kvcKeyPathString!)
    }
    
    var itemsSet: [Item] {
        let set = items as? Set<Item> ?? []
        return set.sorted {
            $0.name < $1.name
        }
    }

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


