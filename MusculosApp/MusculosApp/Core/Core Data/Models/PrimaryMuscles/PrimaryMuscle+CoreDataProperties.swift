//
//  PrimaryMuscle+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 29.03.2024.
//
//

import Foundation
import CoreData


extension PrimaryMuscle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrimaryMuscle> {
        return NSFetchRequest<PrimaryMuscle>(entityName: "PrimaryMuscle")
    }

    @NSManaged public var name: String?
    @NSManaged public var exercise: ExerciseEntity?

}

extension PrimaryMuscle : Identifiable {

}
