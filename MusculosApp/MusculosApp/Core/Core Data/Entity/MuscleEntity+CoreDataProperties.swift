//
//  MuscleEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.09.2023.
//
//

import Foundation
import CoreData
import SwiftUI

extension MuscleEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MuscleEntity> {
        return NSFetchRequest<MuscleEntity>(entityName: "MuscleEntity")
    }

    @NSManaged public var englishName: String
    @NSManaged public var id: Int
    @NSManaged public var imageUrlMain: String
    @NSManaged public var imageUrlSecondary: String
    @NSManaged public var isFront: Bool
    @NSManaged public var latinName: String
}

extension MuscleEntity : Identifiable {
}

extension MuscleEntity {
    var primaryImage: Image {
        return Image("muscles/main/muscle-\(self.id)")
    }
}
