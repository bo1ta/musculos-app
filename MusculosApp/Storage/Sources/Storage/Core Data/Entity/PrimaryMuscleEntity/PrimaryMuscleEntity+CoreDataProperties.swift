//
//  PrimaryMuscleEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.05.2024.
//
//

import Foundation
import CoreData


extension PrimaryMuscleEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<PrimaryMuscleEntity> {
    return NSFetchRequest<PrimaryMuscleEntity>(entityName: "PrimaryMuscleEntity")
  }
  
  @NSManaged public var muscleId: NSNumber
  @NSManaged public var name: String
  @NSManaged public var exercises: Set<ExerciseEntity>
}

// MARK: Generated accessors for exercises
extension PrimaryMuscleEntity {
  @objc(addExercisesObject:)
  @NSManaged public func addToExercises(_ value: ExerciseEntity)
  
  @objc(removeExercisesObject:)
  @NSManaged public func removeFromExercises(_ value: ExerciseEntity)
  
  @objc(addExercises:)
  @NSManaged public func addToExercises(_ values: Set<ExerciseEntity>)
  
  @objc(removeExercises:)
  @NSManaged public func removeFromExercises(_ values: Set<ExerciseEntity>)
}

extension PrimaryMuscleEntity : Identifiable { }

extension PrimaryMuscleEntity: ReadOnlyConvertible {
  public func toReadOnly() -> String {
    return self.name
  }
}
