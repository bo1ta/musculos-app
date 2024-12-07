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
public class ExerciseSessionDataStoreTests: MusculosTestBase {
  @Injected(\StorageContainer.exerciseSessionDataStore) private var dataStore
  @Injected(\StorageContainer.exerciseDataStore) private var exerciseDataStore
  @Injected(\StorageContainer.userDataStore) private var userDataStore

  private func setupCurrentUser() async throws -> UserProfile {
    let profile = UserProfileFactory.createProfile()
    try await userDataStore.createUser(profile: profile)
    return profile
  }

  private func setupExercise() async throws -> Exercise {
    let exercise = ExerciseFactory.createExercise()
    try await exerciseDataStore.add(exercise)
    return exercise
  }
  
  @Test func getAllIsInitiallyEmpty() async throws {
    defer { clearStorage() }

    let profile = try await setupCurrentUser()

    let results = await dataStore.getAll(for: profile.userId)
    #expect(results.count == 0)
  }

  @Test func getCompletedSinceLastWeek() async throws {
    defer { clearStorage() }

    let exercise = try await setupExercise()
    let profile = try await setupCurrentUser()

    let sessionFromToday = ExerciseSessionFactory.createExerciseSession(profile: profile, exercise: exercise)
    try await dataStore.addSession(sessionFromToday)

    let sessionFrom2DaysAgo = ExerciseSessionFactory.createExerciseSession(dateAdded: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, profile: profile, exercise: exercise)
    try await dataStore.addSession(sessionFrom2DaysAgo)

    let sessionFromDistantPast = ExerciseSessionFactory.createExerciseSession(dateAdded: Date.distantPast, profile: profile, exercise: exercise)
    try await dataStore.addSession(sessionFromDistantPast)

    try await Task.sleep(for: .seconds(0.1))

    let results = await dataStore.getCompletedSinceLastWeek(userId: profile.userId)
    #expect(results.count == 2)
  }

  @Test func getCompletedToday() async throws {
    defer { clearStorage() }

    let exercise = try await setupExercise()
    let profile = try await setupCurrentUser()

    let dateFromToday = Date()
    let dateFrom2DaysAgo = try #require(Calendar.current.date(byAdding: .day, value: -2, to: dateFromToday))

    try await dataStore.addSession(ExerciseSessionFactory.createExerciseSession(dateAdded: dateFromToday, profile: profile, exercise: exercise))
    try await dataStore.addSession(ExerciseSessionFactory.createExerciseSession(dateAdded: dateFrom2DaysAgo, profile: profile, exercise: exercise))

    let results = await dataStore.getCompletedToday(userId: profile.userId)
    #expect(results.count == 1)
  }

  @Test func addSession() async throws {
    defer { clearStorage() }

    let exercise = try await setupExercise()
    let profile = try await setupCurrentUser()

    let exerciseSession = ExerciseSessionFactory.createExerciseSession(profile: profile, exercise: exercise)
    try await dataStore.addSession(exerciseSession)

    let results = await dataStore.getAll(for: profile.userId)
    #expect(results.count == 1)

    let result = try #require(results.first)
    #expect(result.exercise.id == exercise.id)
    #expect(result.user.userId == profile.userId)
  }
}
