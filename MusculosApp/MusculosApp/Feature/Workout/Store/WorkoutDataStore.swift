//
//  WorkoutDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.04.2024.
//

import Foundation

struct WorkoutDataStore: BaseDataStore {
  func create(_ workout: Workout) async {
    await writerDerivedStorage.performAndSave {
      guard let user = UserEntity.currentUser(with: writerDerivedStorage) else { return }
      
      let workoutEntity = writerDerivedStorage.insertNewObject(ofType: WorkoutEntity.self)
      workoutEntity.name = workout.name
      workoutEntity.targetMuscles = workout.targetMuscles
      workoutEntity.workoutType = workout.workoutType
      workoutEntity.createdBy = user
      
      /// 1. Fetch the `ExerciseEntity` and return it with the workoutExercise number of reps
      /// 2. Create `WorkoutExerciseEntity` with a one-to-one relationship to the exercise + the number of reps
      /// 3. Insert it into `workoutEntity.workoutExercises`
      ///
      workout.workoutExercises
        .compactMap { workoutExercise -> (ExerciseEntity, Int)? in
          guard let exerciseEntity = writerDerivedStorage.firstObject(
            of: ExerciseEntity.self,
            matching: ExerciseEntity.CommonPredicate.byId(workoutExercise.exercise.id).nsPredicate
          ) else { return nil }
          
          return (exerciseEntity, workoutExercise.numberOfReps)
        }
        .map { (exerciseEntity, numberOfReps) -> WorkoutExerciseEntity in
          let workoutExerciseEntity = writerDerivedStorage.insertNewObject(ofType: WorkoutExerciseEntity.self)
          workoutExerciseEntity.exercise = exerciseEntity
          workoutExerciseEntity.numberOfReps = NSNumber(value: numberOfReps)
          return workoutExerciseEntity
        }
        .forEach { workoutExerciseEntity in
          workoutEntity.addToWorkoutExercises(workoutExerciseEntity)
        }
    }

    await viewStorage.performAndSave {}
  }
  
  @MainActor
  func getAll() async -> [Workout] {
    return viewStorage
      .allObjects(ofType: WorkoutEntity.self, matching: nil, sortedBy: nil)
      .map { $0.toReadOnly() }
  }
}
