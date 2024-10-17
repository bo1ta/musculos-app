//
//  ExerciseSessionDataStoreTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.10.2024.
//

import Testing
import Factory
import Models
import Foundation
import Utility
import XCTest
@testable import Storage

@Suite(.serialized)
public class ExerciseSessionDataStoreTests {
  @Injected(\StorageContainer.exerciseSessionDataStore) private var dataStore
  @Injected(\StorageContainer.exerciseDataStore) private var exerciseDataStore
  @Injected(\StorageContainer.userDataStore) private var userDataStore

  private var profile: UserProfile!
  private var exercise: Exercise!

  init() async throws {
    self.profile = try await setupCurrentUser()
    self.exercise = try await setupExercise()
  }

  private func setupCurrentUser() async throws -> UserProfile {
    let profile = UserProfileFactory.createProfile()
    try await userDataStore.createUser(profile: profile)
    try await Task.sleep(for: .seconds(0.1))
    return profile
  }

  private func setupExercise() async throws -> Exercise {
    let exercise = ExerciseFactory.createExercise()
    try await exerciseDataStore.add(exercise)
    try await Task.sleep(for: .seconds(0.1))
    return exercise
  }
  
  @Test func getAllIsInitiallyEmpty() async throws {
    let results = await dataStore.getAll(for: profile.userId)
    #expect(results.count == 0)
  }

  @Test func getCompletedSinceLastWeek() async throws {
    let dateFromToday = Date()
    let dateFrom2DaysAgo = try #require(Calendar.current.date(byAdding: .day, value: -2, to: dateFromToday))
    let dateFromDistantPast = Date.distantPast

    try await dataStore.addSession(exercise,date: dateFromToday, duration: 1, userId: profile.userId)
    try await dataStore.addSession(exercise, date: dateFrom2DaysAgo, duration: 2, userId: profile.userId)
    try await dataStore.addSession(exercise, date: dateFromDistantPast, duration: 2, userId: profile.userId)
    try await Task.sleep(for: .seconds(0.1))

    let results = await dataStore.getCompletedSinceLastWeek(userId: profile.userId)
    #expect(results.count == 2)

    StorageContainer.shared.storageManager().reset()
  }

  @Test func getCompletedToday() async throws {
    let dateFromToday = Date()
    let dateFrom2DaysAgo = try #require(Calendar.current.date(byAdding: .day, value: -2, to: dateFromToday))

    try await dataStore.addSession(exercise,date: dateFromToday, duration: 1, userId: profile.userId)
    try await dataStore.addSession(exercise, date: dateFrom2DaysAgo, duration: 2, userId: profile.userId)
    try await Task.sleep(for: .seconds(0.1))

    let results = await dataStore.getCompletedToday(userId: profile.userId)
    #expect(results.count == 1)

    StorageContainer.shared.storageManager().reset()
  }

  @Test func addSession() async throws {
    try await dataStore.addSession(
      exercise,
      date: Date(),
      duration: 1,
      userId: profile.userId
    )
    try await Task.sleep(for: .seconds(0.1))

    let results = await dataStore.getAll(for: profile.userId)
    #expect(results.count == 1)

    let result = try #require(results.first)
    #expect(result.exercise.id == exercise.id)
    #expect(result.user.userId == profile.userId)

    StorageContainer.shared.storageManager().reset()
  }
}
