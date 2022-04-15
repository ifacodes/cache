//
//  Cache+CoreDataProperties.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-15.
//
//

import Foundation
import CoreData


extension Cache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cache> {
        return NSFetchRequest<Cache>(entityName: "Cache")
    }

    @NSManaged public var name: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var boxes: Box?
    @NSManaged public var items: Item?

}

extension Cache : Identifiable {

}
