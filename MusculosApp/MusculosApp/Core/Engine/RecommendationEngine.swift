//
//  RecommendationEngine.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.07.2024.
//

import Foundation
import Models
import Storage
@preconcurrency import Factory
import Utility

public struct RecommendationEngine: Sendable {
  @Injected(\.exerciseDataStore) private var exerciseDataStore
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore
  @Injected(\.goalDataStore) private var goalDataStore
  @Injected(\.userDataStore) private var userDataStore
  
  public func recommendByGoals() async throws -> [Exercise] {
    guard await UserSessionActor.shared.currentUser() != nil else {
      throw MusculosError.notFound
    }
    
    let goals = await goalDataStore.getAll()
    guard !goals.isEmpty else {
      throw RecommendationError.emptyGoals
    }
    
    return await exerciseDataStore.getAllByGoals(goals, fetchLimit: 20)
  }

  public func recommendByMuscleGroups() async throws -> [Exercise] {
    guard let currentUser = await UserSessionActor.shared.currentUser() else {
      return []
    }
    
    let exerciseSessions = await exerciseSessionDataStore.getAll(for: currentUser.userId)
    guard !exerciseSessions.isEmpty else {
      throw RecommendationError.emptyExerciseSessions
    }
    
    let muscles = Array(Set(exerciseSessions.flatMap { $0.exercise.muscleTypes }))
    return await exerciseDataStore.getAllExcludingMuscles(muscles)
  }
}


// MARK: - Utils

extension RecommendationEngine {
  enum RecommendationError: LocalizedError, CustomStringConvertible {
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
