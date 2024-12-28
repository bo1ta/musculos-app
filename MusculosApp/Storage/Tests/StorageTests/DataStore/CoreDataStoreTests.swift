//
//  CoreDataStoreTests.swift
//  Storage
//
//  Created by Solomon Alexandru on 16.12.2024.
//

import Factory
import Foundation
import Models
@testable import Storage
import Testing

@Suite(.serialized)
public class CoreDataStoreTests: MusculosTestBase {
  @Injected(\StorageContainer.coreDataStore) private var dataStore

  @Test func getAll() async throws {
    let exercises = await dataStore.getAll(ExerciseEntity.self)
    #expect(exercises.isEmpty)
  }

  @Test func importModel() async throws {
    let exercise = ExerciseFactory.createExercise()

    let dataStore = CoreDataStore()
    try await dataStore.importModel(exercise, of: ExerciseEntity.self)

    let local = await dataStore.firstObject(ExerciseEntity.self, predicate: PredicateProvider.exerciseById(exercise.id))
    #expect(local?.name == exercise.name)
  }

  @Test func getByMuscles() async throws {
    let exercise = ExerciseFactory.createExercise(
      name: "First Exercise",
      primaryMuscles: [MuscleType.chest.rawValue]
    )
    try await dataStore.importModel(exercise, of: ExerciseEntity.self)

    let fetchedExercises = await dataStore.exercisesForMuscles([.chest])
    let firstExercise = try #require(fetchedExercises.first(where: { $0.id == exercise.id }))
    #expect(firstExercise.name == exercise.name)
  }

  private func setupCurrentUser() async throws -> UserProfile {
    let profile = UserProfileFactory.createProfile()
    try await dataStore.importModel(profile, of: UserProfileEntity.self)
    return profile
  }

  private func setupExercise() async throws -> Exercise {
    let exercise = ExerciseFactory.createExercise()
    try await dataStore.importModel(exercise, of: ExerciseEntity.self)
    return exercise
  }

  @Test func getCompletedSinceLastWeek() async throws {
    let exercise = try await setupExercise()
    let profile = try await setupCurrentUser()

    let sessionFromToday = ExerciseSessionFactory.createExerciseSession(profile: profile, exercise: exercise)
    try await dataStore.importModel(sessionFromToday, of: ExerciseSessionEntity.self)

    let dateFrom2DaysAgo = try #require(Calendar.current.date(byAdding: .day, value: -2, to: Date()))
    let sessionFrom2DaysAgo = ExerciseSessionFactory.createExerciseSession(
      dateAdded: dateFrom2DaysAgo,
      profile: profile,
      exercise: exercise
    )
    try await dataStore.importModel(sessionFrom2DaysAgo, of: ExerciseSessionEntity.self)

    let sessionFromDistantPast = ExerciseSessionFactory.createExerciseSession(dateAdded: Date.distantPast, profile: profile, exercise: exercise)
    try await dataStore.importModel(sessionFromDistantPast, of: ExerciseSessionEntity.self)

    try await Task.sleep(for: .seconds(0.1))

    let results = await dataStore.exerciseSessionsCompletedSinceLastWeek(for: profile.userId)
    #expect(results.count == 2)
  }
}
