//
//  Item+CoreDataProperties.swift
//  cache
//
//  Created by Aoife Bradley on 2022-02-25.
//
//

import Foundation
import CoreData
import SwiftUI

extension Item {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }
    
    // MARK: - Attributes
    @NSManaged public var name: String
    @NSManaged public var itemDescription: String?
    @NSManaged public var updatedTimestamp: Date?
    @NSManaged public var createdTimestamp: Date
    @NSManaged public var image: UIImage?
    @NSManaged private var meas_x_cm: NSDecimalNumber?
    @NSManaged private var meas_y_cm: NSDecimalNumber?
    @NSManaged private var meas_z_cm: NSDecimalNumber?
    @NSManaged private var weight_g: NSDecimalNumber?
    
    // MARK: - Relationships
    @NSManaged public var cache: Cache?
    @NSManaged public var box: Box?
    @NSManaged public var tags: Set<Tag>
    
    // MARK: - UUID
    @NSManaged public var uuid: UUID
    
    var tagList: [TagModel] {
        return tags.sorted {
            $0.name < $1.name
        }.map { tag in
            return TagModel(tag)
        }
    }
}

// MARK: Generated accessors for items
extension Item {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension Item : Identifiable {
    
}

// MARK: - Metric Computed Properties
extension Item {
    
    public var dimensions: [Decimal] {
        get {
            return [meas_x_cm?.decimalValue ?? 0, meas_y_cm?.decimalValue ?? 0, meas_z_cm?.decimalValue ?? 0]
        }
        set {
            guard newValue.count == 3 else {
                return
            }
            meas_x_cm = NSDecimalNumber(decimal: newValue[0])
            meas_y_cm = NSDecimalNumber(decimal: newValue[1])
            meas_z_cm = NSDecimalNumber(decimal: newValue[2])
        }
    }
    
    public var g: Decimal {
        get {
            return weight_g?.decimalValue ?? 0
        }
        set {
            weight_g = NSDecimalNumber(decimal: newValue)
        }
    }
    
}
