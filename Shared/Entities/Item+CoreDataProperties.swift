//
//  Item+CoreDataProperties.swift
//  cache
//
//  Created by Aoife Bradley on 2022-02-25.
//
//

import Foundation
import CoreData

enum Location: Int64, CaseIterable {
    case onPerson = 0
    case inStorage
}

extension Location: CustomStringConvertible {
    var description: String {
            switch self {
                // MARK: Localization can be done here
            case .onPerson:     return "On Person"
            case .inStorage:    return "In Storage"
            }
    }
}


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String
    @NSManaged public var timestamp: Date?
    @NSManaged public var box: Box?
    @NSManaged public var locationRaw: Int64
    @NSManaged public var uuid: UUID
    @NSManaged public var category: Category?
    @NSManaged public var cache: Cache?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID(), forKey: (\Item.uuid)._kvcKeyPathString!)
    }
    
}

extension Item {
    var location: Location {
        get {
            return Location(rawValue: locationRaw)!
        }
        set {
            locationRaw = newValue.rawValue
        }
    }
}

extension Item : Identifiable {

}
