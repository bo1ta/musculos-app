//
//  RecommendationEngine.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.06.2024.
//

import Foundation
@preconcurrency import Models

public struct RecommendationEngine {
//  let exerciseDataStore: ExerciseDataStoreProtocol
//  let exerciseSessionDataStore: ExerciseSessionDataStoreProtocol
//  let goalDataStore: GoalDataStoreProtocol
//  let userDataStore: UserDataStoreProtocol
//  
//  public init(
//    exerciseDataStore: ExerciseDataStoreProtocol,
//    exerciseSessionDataStore: ExerciseSessionDataStoreProtocol,
//    goalDataStore: GoalDataStoreProtocol,
//    userDataStore: UserDataStoreProtocol
//  ) {
//    self.exerciseDataStore = exerciseDataStore
//    self.exerciseSessionDataStore = exerciseSessionDataStore
//    self.goalDataStore = goalDataStore
//    self.userDataStore = userDataStore
//  }
//  
//  public func recommendByGoals(for user: UserProfile) async throws -> [Exercise] {
//    let goals = await goalDataStore.getAll()
//    guard !goals.isEmpty else {
//      throw RecommendationError.emptyGoals
//    }
//    
//    return await exerciseDataStore.getAllByGoals(goals, fetchLimit: 20)
//  }
//
//  public func recommendByMuscleGroups(for user: UserProfile) async throws -> [Exercise] {
//    let exerciseSessions = await exerciseSessionDataStore.getAll()
//    guard !exerciseSessions.isEmpty else {
//      throw RecommendationError.emptyExerciseSessions
//    }
//    
//    let muscles = Array(Set(exerciseSessions.flatMap { $0.exercise.muscleTypes }))
//    return await exerciseDataStore.getAllExcludingMuscles(muscles)
//  }
}


// MARK: - Utils

public extension RecommendationEngine {
  public enum RecommendationError: LocalizedError, CustomStringConvertible {
    case emptyGoals, emptyExerciseSessions
    
    public var description: String {
      switch self {
      case .emptyGoals:
        return "No goals set!"
      case .emptyExerciseSessions:
        return "No exercises completed yet!"
      }
    }
  }
}
