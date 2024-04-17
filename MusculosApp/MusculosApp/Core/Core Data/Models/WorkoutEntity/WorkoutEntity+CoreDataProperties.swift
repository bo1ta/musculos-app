//
//  WorkoutEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//
//

import Foundation
import CoreData


extension WorkoutEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var targetMuscles: [String]
    @NSManaged public var workoutType: String
    @NSManaged public var createdBy: UserEntity
    @NSManaged public var workoutExercises: Set<WorkoutExerciseEntity>

}

// MARK: Generated accessors for workoutExercises
extension WorkoutEntity {

    @objc(addWorkoutExercisesObject:)
    @NSManaged public func addToWorkoutExercises(_ value: WorkoutExerciseEntity)

    @objc(removeWorkoutExercisesObject:)
    @NSManaged public func removeFromWorkoutExercises(_ value: WorkoutExerciseEntity)

    @objc(addWorkoutExercises:)
    @NSManaged public func addToWorkoutExercises(_ values: NSSet)

    @objc(removeWorkoutExercises:)
    @NSManaged public func removeFromWorkoutExercises(_ values: NSSet)

}

extension WorkoutEntity : Identifiable {}

extension WorkoutEntity: ReadOnlyConvertible {
  func toReadOnly() -> Workout {
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
