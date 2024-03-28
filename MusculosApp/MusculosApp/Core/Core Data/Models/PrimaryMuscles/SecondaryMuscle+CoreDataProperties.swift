//
//  SecondaryMuscle+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 29.03.2024.
//
//

import Foundation
import CoreData


extension SecondaryMuscle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SecondaryMuscle> {
        return NSFetchRequest<SecondaryMuscle>(entityName: "SecondaryMuscle")
    }

    @NSManaged public var name: String?
    @NSManaged public var exercise: ExerciseEntity?

}

extension SecondaryMuscle : Identifiable {

}
