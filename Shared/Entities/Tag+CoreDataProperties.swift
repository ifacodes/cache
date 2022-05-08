//
//  Tag+CoreDataProperties.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-29.
//
//

import Foundation
import CoreData
import SwiftUI

extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String
    @NSManaged public var uuid: UUID
    @NSManaged public var color: UIColor
    @NSManaged public var items: NSSet?

}

extension Tag : Identifiable {
    
}
