//
//  WorkoutDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.04.2024.
//

import Foundation
import Models

public protocol WorkoutDataStoreProtocol: Sendable {
  func create(_ workout: Workout) async throws
  func getAll() async -> [Workout]
}

public struct WorkoutDataStore: BaseDataStore, WorkoutDataStoreProtocol {
  
  public init() { }
  
  public func create(_ workout: Workout) async throws {
    try await storageManager.performWriteOperation { writerDerivedStorage in
      guard let user = UserEntity.currentUser(with: writerDerivedStorage) else { return }
      
      let workoutEntity = writerDerivedStorage.insertNewObject(ofType: WorkoutEntity.self)
      workoutEntity.name = workout.name
      workoutEntity.targetMuscles = workout.targetMuscles
      workoutEntity.workoutType = workout.workoutType
      workoutEntity.createdBy = user
      
      /// 1. Fetch the `ExerciseEntity`
      /// 2. Create `WorkoutExerciseEntity` with a one-to-one relationship to the exercise + the number of reps
      /// 3. Insert it into `workoutEntity.workoutExercises`
      ///
      for workoutExercise in workout.workoutExercises {
        guard let exerciseEntity = writerDerivedStorage.firstObject(
          of: ExerciseEntity.self,
          matching: ExerciseEntity.CommonPredicate.byId(workoutExercise.exercise.id).nsPredicate
        ) else { return }
        
        let workoutExerciseEntity = writerDerivedStorage.insertNewObject(ofType: WorkoutExerciseEntity.self)
        workoutExerciseEntity.exercise = exerciseEntity
        workoutExerciseEntity.numberOfReps = NSNumber(value: workoutExercise.numberOfReps)
        
        workoutEntity.addToWorkoutExercises(workoutExerciseEntity)
      }
    }
  }
  
  public func getAll() async -> [Workout] {
    return await storageManager.performReadOperation { viewStorage in
      return viewStorage
        .allObjects(ofType: WorkoutEntity.self, matching: nil, sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }
}
