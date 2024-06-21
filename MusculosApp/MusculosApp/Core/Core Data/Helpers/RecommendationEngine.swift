//
//  RecommendationEngine.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.06.2024.
//

import Foundation
import Factory

actor RecommendationEngine {
  @Injected(\.dataStore) private var dataStore: DataStoreProtocol
  
  // MARK: - Recommendations by Goals
  
  func recommendByGoals() async throws -> [Exercise]? {
    guard await dataStore.loadCurrentUser() != nil else {
      throw MusculosError.notFound
    }
    
    let goals = await dataStore.loadGoals()
    guard !goals.isEmpty else { return nil }
    
    return await dataStore.exerciseDataStore.getAllByGoals(goals, fetchLimit: 20)
  }
  
  // MARK: - Recommendations by Muscles
  
  func recommendByMuscleGroups() async throws -> [Exercise]? {
    guard await dataStore.loadCurrentUser() != nil else {
      throw MusculosError.notFound
    }
    
    let exerciseSessions = await dataStore.loadExerciseSessions()
    guard !exerciseSessions.isEmpty else { return nil }
    
    let muscles = Array(Set(exerciseSessions.flatMap { $0.exercise.muscleTypes }))
    return await dataStore.exerciseDataStore.getAllExcludingMuscles(muscles)
    
  }
}


// MARK: - Utils

extension RecommendationEngine {
  enum RecommendationError: LocalizedError, CustomStringConvertible {
    case emptyGoals, emptyExerciseSessions
    
    var description: String {
      switch self {
      case .emptyGoals:
        return "No goals set!"
      case .emptyExerciseSessions:
        return "No exercises completed yet!"
      }
    }
  }
}
