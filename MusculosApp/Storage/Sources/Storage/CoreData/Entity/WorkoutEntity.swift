//
//  WorkoutEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//
//

import Foundation
import CoreData
import Models

@objc(WorkoutEntity)
class WorkoutEntity: NSManagedObject {
  @NSManaged var name: String
  @NSManaged var targetMuscles: [String]
  @NSManaged var workoutType: String
  @NSManaged var createdBy: UserProfileEntity
  @NSManaged var workoutExercises: Set<WorkoutExerciseEntity>

  @nonobjc class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
    return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
  }
}

// MARK: Generated accessors for workoutExercises
extension WorkoutEntity {

  @objc(addWorkoutExercisesObject:)
  @NSManaged func addToWorkoutExercises(_ value: WorkoutExerciseEntity)

  @objc(removeWorkoutExercisesObject:)
  @NSManaged func removeFromWorkoutExercises(_ value: WorkoutExerciseEntity)

  @objc(addWorkoutExercises:)
  @NSManaged func addToWorkoutExercises(_ values: NSSet)

  @objc(removeWorkoutExercises:)
  @NSManaged func removeFromWorkoutExercises(_ values: NSSet)

}

extension WorkoutEntity : Identifiable {}

extension WorkoutEntity: ReadOnlyConvertible {
  public func toReadOnly() -> Workout {
    let workoutExercisesToRead = workoutExercises.compactMap { $0.toReadOnly() }
    let person = createdBy.toReadOnly()
    
    return Workout(
      name: name,
      targetMuscles: targetMuscles,
      workoutType: workoutType,
      createdBy: person,
      workoutExercises: workoutExercisesToRead
    )
  }
}
