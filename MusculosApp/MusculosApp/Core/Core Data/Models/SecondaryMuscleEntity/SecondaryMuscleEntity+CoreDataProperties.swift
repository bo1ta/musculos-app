//
//  SecondaryMuscleEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.05.2024.
//
//

import Foundation
import CoreData


extension SecondaryMuscleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SecondaryMuscleEntity> {
        return NSFetchRequest<SecondaryMuscleEntity>(entityName: "SecondaryMuscleEntity")
    }

    @NSManaged public var muscleId: NSNumber
    @NSManaged public var name: String
    @NSManaged public var exercises: Set<ExerciseEntity>

}

// MARK: Generated accessors for exercises
extension SecondaryMuscleEntity {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseEntity)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseEntity)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: Set<ExerciseEntity>)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: Set<ExerciseEntity>)

}

extension SecondaryMuscleEntity : Identifiable { }

extension SecondaryMuscleEntity: ReadOnlyConvertible {
  func toReadOnly() -> String {
    return name
  }
}
