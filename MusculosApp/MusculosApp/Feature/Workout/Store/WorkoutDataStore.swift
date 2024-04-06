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
      
      /// Fetch the  `Exercise` entity and insert it into  `workoutEntity.exercises`
      ///
      workout.exercises
        .compactMap {
          writerDerivedStorage.firstObject(of: ExerciseEntity.self,
                                           matching: ExerciseEntity.CommonPredicate.byId($0.id).nsPredicate)
        }
        .forEach { workoutEntity.addToExercises($0) }
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
