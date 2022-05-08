//
//  Cache+CoreDataProperties.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-15.
//
//

import Foundation
import CoreData
import SwiftUI

// MARK: - CacheIcon

enum CacheIcon {
    case emoji(String)
    case symbol(String)
}

extension Cache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cache> {
        return NSFetchRequest<Cache>(entityName: "Cache")
    }

    @NSManaged public var name: String
    @NSManaged public var uuid: UUID
    @NSManaged public var boxes: Set<Box>
    @NSManaged public var items: Set<Item>
    @NSManaged public var iconString: String
    @NSManaged public var uiColor: UIColor?
    
    var color: Color? {
        get {
            guard let uiColor = uiColor else {
                return nil
            }
            return Color(uiColor)
        }
//        set {
//            guard let color = newValue else {
//                return
//            }
//            uiColor = UIColor(color)
//        }
    }
    
    var icon: CacheIcon {
        get {
            let components = iconString.components(separatedBy: ":")
            if components.first == "emoji" {
                return .emoji(components.last!)
            } else {
                return .symbol(components.last!)
            }
            
        } set {
            switch newValue {
            case .emoji(let icon):
                iconString = "emoji:\(icon)"
            case .symbol(let icon):
                iconString = "symbol:\(icon)"
            }
        }
    }

}

// MARK: Generated accessors for items
extension Cache {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)
    
    @objc(addBoxesObject:)
    @NSManaged public func addToBoxes(_ value: Box)

    @objc(removeBoxesObject:)
    @NSManaged public func removeFromBoxes(_ value: Box)

    @objc(addBoxes:)
    @NSManaged public func addToBoxes(_ values: NSSet)

    @objc(removeBoxes:)
    @NSManaged public func removeFromBoxes(_ values: NSSet)

}

extension Cache : Identifiable {

}

extension Cache {
    
    static var userCaches: NSFetchRequest<Cache> {
        let request = NSFetchRequest<Cache>(entityName: "Cache")
        request.affectedStores = [ PersistenceController.shared.container.persistentStoreCoordinator.persistentStores.first!]
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Cache.name, ascending: true)]
        return request
    }
    
    var badge: Int {
        items.underestimatedCount
    }
    
}
