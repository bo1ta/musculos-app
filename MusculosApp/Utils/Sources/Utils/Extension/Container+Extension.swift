//
//  Container+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.05.2024.
//

import Foundation
import Factory

extension Container {
  var storageManager: Factory<StorageManagerType> {
    self { StorageManager() }
      .onTest { _ in
        InMemoryStorageManager()
      }
      .singleton
  }
  
  var dataStore: Factory<DataStoreProtocol> {
    self { DataStore() }
      .singleton
  }
  
  var exerciseDataStore: Factory<ExerciseDataStoreProtocol> {
    self { ExerciseDataStore() }
  }
  
  var userDataStore: Factory<UserDataStoreProtocol> {
    self { UserDataStore() }
  }
  
  var exerciseSessionDataStore: Factory<ExerciseSessionDataStoreProtocol> {
    self { ExerciseSessionDataStore() }
  }
  
  var goalDataStore: Factory<GoalDataStoreProtocol> {
    self { GoalDataStore() }
  }
  
  var workoutDataStore: Factory<WorkoutDataStoreProtocol> {
    self { WorkoutDataStore() }
  }
  
  var exerciseService: Factory<ExerciseServiceProtocol> {
    self { ExerciseService() }
  }
  
  var recommendationEngine: Factory<RecommendationEngine> {
    self { RecommendationEngine() }
  }
}
