//
//  WorkoutExerciseEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//
//

import Foundation
import CoreData

extension WorkoutExerciseEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutExerciseEntity> {
    return NSFetchRequest<WorkoutExerciseEntity>(entityName: "WorkoutExerciseEntity")
  }
  
  @NSManaged public var numberOfReps: NSNumber
  @NSManaged public var exercise: ExerciseEntity
  @NSManaged public var workout: WorkoutEntity?
}

extension WorkoutExerciseEntity : Identifiable { }

extension WorkoutExerciseEntity: ReadOnlyConvertible {
  func toReadOnly() -> WorkoutExercise {
    return WorkoutExercise(
      numberOfReps: self.numberOfReps.intValue,
      exercise: exercise.toReadOnly()
    )
  }
}
