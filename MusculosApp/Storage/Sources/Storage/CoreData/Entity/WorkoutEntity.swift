//
//  WorkoutEntity.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//
//

import CoreData
import Foundation
import Models

// MARK: - WorkoutEntity

@objc(WorkoutEntity)
class WorkoutEntity: NSManagedObject {
  @NSManaged var modelID: UUID
  @NSManaged var name: String
  @NSManaged var targetMuscles: [String]
  @NSManaged var workoutType: String
  @NSManaged var createdBy: UserProfileEntity
  @NSManaged var workoutExercises: Set<WorkoutExerciseEntity>

  @nonobjc
  class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
    NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
  }
}

// MARK: Generated accessors for workoutExercises

extension WorkoutEntity {
  @objc(addWorkoutExercisesObject:)
  @NSManaged
  func addToWorkoutExercises(_ value: WorkoutExerciseEntity)

  @objc(removeWorkoutExercisesObject:)
  @NSManaged
  func removeFromWorkoutExercises(_ value: WorkoutExerciseEntity)

  @objc(addWorkoutExercises:)
  @NSManaged
  func addToWorkoutExercises(_ values: NSSet)

  @objc(removeWorkoutExercises:)
  @NSManaged
  func removeFromWorkoutExercises(_ values: NSSet)
}

// MARK: Identifiable

extension WorkoutEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension WorkoutEntity: ReadOnlyConvertible {
  public func toReadOnly() -> Workout {
    let workoutExercisesToRead = workoutExercises.compactMap { $0.toReadOnly() }
    let person = createdBy.toReadOnly()

    return Workout(
      id: modelID,
      name: name,
      targetMuscles: targetMuscles,
      workoutType: workoutType,
      createdBy: person,
      workoutExercises: workoutExercisesToRead)
  }
}

// MARK: EntitySyncable

extension WorkoutEntity: EntitySyncable {
  func populateEntityFrom(_ model: Workout, using storage: any StorageType) {
    modelID = model.id
    name = model.name
    targetMuscles = model.targetMuscles
    workoutType = model.workoutType
    createdBy = UserProfileEntity.entityFrom(model.createdBy, using: storage)
    workoutExercises = getWorkoutExercisesFrom(model.workoutExercises, storage: storage)
  }

  func updateEntityFrom(_: Workout, using _: any StorageType) { }

  private func getWorkoutExercisesFrom(
    _ workoutExercises: [WorkoutExercise],
    storage: StorageType)
    -> Set<WorkoutExerciseEntity>
  {
    Set(workoutExercises.map {
      WorkoutExerciseEntity.findOrCreate($0, using: storage)
    })
  }

  static func findOrCreate(_ workout: Workout, from storage: StorageType) -> WorkoutEntity {
    if let entity = storage.firstObject(of: WorkoutEntity.self, matching: PredicateProvider.workoutByID(workout.id)) {
      return entity
    }

    let entity = storage.insertNewObject(ofType: WorkoutEntity.self)
    entity.populateEntityFrom(workout, using: storage)
    return entity
  }
}
