//
//  WorkoutDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.04.2024.
//

import Foundation

struct WorkoutDataStore: BaseDataStore {
  func createWorkout(_ workout: Workout) async {
    await self.writerDerivedStorage.performAndSave {
      let workoutEntity = self.writerDerivedStorage.insertNewObject(ofType: WorkoutEntity.self)
      workoutEntity.name = workout.name
      workoutEntity.targetMuscles = workout.targetMuscles
      workoutEntity.createdBy = UserEntity.currentUser(with: self.writerDerivedStorage)!
      workoutEntity.workoutType = workout.workoutType
      
      /// Fetch the  `Exercise` entity and insert it into  `workoutEntity.exercises`
      ///
      workout.exercises
        .compactMap {
          self.writerDerivedStorage.firstObject(
            of: ExerciseEntity.self,
            matching: ExerciseEntity.CommonPredicate.byId($0.id).nsPredicate
          )
        }
        .forEach { workoutEntity.addToExercises($0) }
    }

    await self.viewStorage.performAndSave {}
  }
  
  @MainActor
  func getAllWorkouts() async -> [Workout] {
    return self.viewStorage
      .allObjects(ofType: WorkoutEntity.self, matching: nil, sortedBy: nil)
      .map { $0.toReadOnly() }
  }
}
