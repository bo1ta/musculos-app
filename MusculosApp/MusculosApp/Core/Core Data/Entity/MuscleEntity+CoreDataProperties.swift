//
//  MuscleEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.09.2023.
//
//

import Foundation
import CoreData


extension MuscleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MuscleEntity> {
        return NSFetchRequest<MuscleEntity>(entityName: "MuscleEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var latinName: String?
    @NSManaged public var englishName: String?
    @NSManaged public var isFront: Bool
    @NSManaged public var imageUrlMain: String?
    @NSManaged public var imageUrlSecondary: String?

}

extension MuscleEntity : Identifiable {

}
