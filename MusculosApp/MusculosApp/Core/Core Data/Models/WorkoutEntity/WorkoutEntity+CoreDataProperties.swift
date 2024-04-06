//
//  WorkoutEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 05.04.2024.
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
  @NSManaged public var exercises: Set<ExerciseEntity>
}

// MARK: Generated accessors for exercises
extension WorkoutEntity {
  
  @objc(addExercisesObject:)
  @NSManaged public func addToExercises(_ value: ExerciseEntity)
  
  @objc(removeExercisesObject:)
  @NSManaged public func removeFromExercises(_ value: ExerciseEntity)
  
  @objc(addExercises:)
  @NSManaged public func addToExercises(_ values: NSSet)
  
  @objc(removeExercises:)
  @NSManaged public func removeFromExercises(_ values: NSSet)
  
}

struct Workout {
  let name: String
  let targetMuscles: [String]
  let workoutType: String
  let createdBy: Person?
  let exercises: [Exercise]
  
  init(name: String, targetMuscles: [String], workoutType: String, createdBy: Person? = nil, exercises: [Exercise]) {
    self.name = name
    self.targetMuscles = targetMuscles
    self.workoutType = workoutType
    self.createdBy = createdBy
    self.exercises = exercises
  }
}

extension WorkoutEntity: Identifiable {}

extension WorkoutEntity: ReadOnlyConvertible {
  func toReadOnly() -> Workout {
    let exercisesToRead = exercises.compactMap { $0.toReadOnly() }
    let person = createdBy.toReadOnly()

    return Workout(
      name: name,
      targetMuscles: targetMuscles,
      workoutType: workoutType,
      createdBy: person,
      exercises: exercisesToRead
    )
  }
  
  func update(with entity: Workout) {
    
  }
}
