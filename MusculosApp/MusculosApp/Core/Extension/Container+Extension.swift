//
//  Container+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.05.2024.
//

import Foundation
import Factory
import Storage
import Utility

extension Container {
  var storageManager: Factory<StorageManagerType> {
    self { StorageManager() }
      .onTest { _ in
        InMemoryStorageManager()
      }
      .singleton
  }

  var client: Factory<MusculosClientProtocol> {
    self { MusculosClient() }
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

  var authService: Factory<AuthServiceProtocol> {
    self { AuthService() }
  }

  var userManager: Factory<UserManagerProtocol> {
    self { UserManager() }.cached
  }

  var taskManager: Factory<TaskManagerProtocol> {
    self { TaskManager() }.unique
  }
}
