//
//  DataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.06.2024.
//

import Foundation
import Factory

protocol DataStoreProtocol: Actor {
  var goalDataStore: GoalDataStoreProtocol { get }
  var userDataStore: UserDataStoreProtocol { get }
  var exerciseDataStore: ExerciseDataStoreProtocol { get }
  var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol { get }
  
  func loadExercises(fetchLimit: Int) async -> [Exercise]
  func loadGoals() async -> [Goal]
  func loadExerciseSessions() async -> [ExerciseSession]
  func loadCurrentUser() async -> User?
  
  func invalidateAllCache() async
  func invalidateExercises() async
  func invalidatePerson() async
  func invalidateGoals() async
  func invalidateExerciseSessions() async
}

actor DataStore: DataStoreProtocol {
  @Injected(\.goalDataStore) var goalDataStore: GoalDataStoreProtocol
  @Injected(\.userDataStore) var userDataStore: UserDataStoreProtocol
  @Injected(\.exerciseSessionDataStore) var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol
  @Injected(\.exerciseDataStore) var exerciseDataStore: ExerciseDataStoreProtocol
  
  private var cachedExercises: [Exercise]?
  private var cachedUser: User?
  private var cachedGoals: [Goal]?
  private var cachedExerciseSessions: [ExerciseSession]?
  
  func loadExercises(fetchLimit: Int = 20) async -> [Exercise] {
    if let cachedExercises {
      return cachedExercises
    } else {
      let exercises = await exerciseDataStore.getAll(fetchLimit: fetchLimit)
      cachedExercises = exercises
      return exercises
    }
  }
  
  func loadGoals() async -> [Goal] {
    if let cachedGoals {
      return cachedGoals
    } else {
      let goals = await goalDataStore.getAll()
      cachedGoals = goals
      return goals
    }
  }
  
  func loadExerciseSessions() async -> [ExerciseSession] {
    if let cachedExerciseSessions {
      return cachedExerciseSessions
    } else {
      let exerciseSessions = await exerciseSessionDataStore.getCompletedSinceLastWeek()
      cachedExerciseSessions = exerciseSessions
      return exerciseSessions
    }
  }
  
  func loadCurrentUser() async -> User? {
    if let cachedUser {
      return cachedUser
    } else {
      let person = await userDataStore.loadCurrentUser()
      cachedUser = person
      return person
    }
  }
  
  func invalidateAllCache() {
    cachedExercises = nil
    cachedUser = nil
    cachedGoals = nil
    cachedExerciseSessions = nil
  }
  
  func invalidateExercises() {
    cachedExercises = nil
  }
  
  func invalidatePerson() {
    cachedUser = nil
  }
  
  func invalidateGoals() {
    cachedGoals = nil
  }
  
  func invalidateExerciseSessions() {
    cachedExerciseSessions = nil
  }
}
