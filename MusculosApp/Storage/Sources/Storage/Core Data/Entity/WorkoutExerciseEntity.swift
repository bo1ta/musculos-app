//
//  WorkoutExerciseEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//
//

import Foundation
import CoreData
import Models

@objc(WorkoutExerciseEntity)
public class WorkoutExerciseEntity: NSManagedObject {
  @NSManaged public var numberOfReps: NSNumber
  @NSManaged public var exercise: ExerciseEntity
  @NSManaged public var workout: WorkoutEntity?

  @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutExerciseEntity> {
    return NSFetchRequest<WorkoutExerciseEntity>(entityName: "WorkoutExerciseEntity")
  }
}

extension WorkoutExerciseEntity : Identifiable { }

extension WorkoutExerciseEntity: ReadOnlyConvertible {
  public func toReadOnly() -> WorkoutExercise {
    return WorkoutExercise(
      numberOfReps: self.numberOfReps.intValue,
      exercise: exercise.toReadOnly()
    )
  }
}
