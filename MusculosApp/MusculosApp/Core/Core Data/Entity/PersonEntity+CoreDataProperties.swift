//
//  PersonEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//
//

import Foundation
import CoreData

extension PersonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonEntity> {
        return NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var personId: Int
    @NSManaged public var name: String?
    @NSManaged public var weight: NSNumber?
}

extension PersonEntity: Identifiable {

}
