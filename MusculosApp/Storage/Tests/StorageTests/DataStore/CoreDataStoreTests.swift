//
//  CoreDataStoreTests.swift
//  Storage
//
//  Created by Solomon Alexandru on 16.12.2024.
//

import Factory
import Foundation
import Models
import Testing
@testable import Storage

@Suite(.serialized)
public class CoreDataStoreTests: MusculosTestBase {
  @Injected(\StorageContainer.coreDataStore) private var dataStore

  @Test
  func getAll() async throws {
    let exercises = await dataStore.getAll(ExerciseEntity.self)
    #expect(exercises.isEmpty)
  }

  @Test
  func importModel() async throws {
    let factory = ExerciseFactory()
    let exercise = factory.create()
    await factory.awaitPendingOperations()

    let dataStore = CoreDataStore()
    let local = await dataStore.firstObject(ExerciseEntity.self, predicate: PredicateProvider.exerciseById(exercise.id))
    #expect(local?.name == exercise.name)
  }

  @Test
  func getByMuscles() async throws {
    let factory = ExerciseFactory()
    factory.name = "First Exercise"
    factory.primaryMuscles = [MuscleType.chest.rawValue]

    let exercise = factory.create()
    await factory.awaitPendingOperations()

    let fetchedExercises = await dataStore.exercisesForMuscles([.chest])
    let firstExercise = try #require(fetchedExercises.first(where: { $0.id == exercise.id }))
    #expect(firstExercise.name == exercise.name)
  }

  @Test
  func getCompletedSinceLastWeek() async throws {
    let exercise = try await setupExercise()
    let profile = try await setupCurrentUser()

    var factory = ExerciseSessionFactory()
    factory.user = profile
    factory.exercise = exercise

    let sessionFromToday = factory.create()

    factory = ExerciseSessionFactory()
    factory.user = profile
    factory.exercise = exercise
    factory.dateAdded = try #require(Calendar.current.date(byAdding: .day, value: -2, to: Date()))

    let sessionFrom2DaysAgo = factory.create()

    factory = ExerciseSessionFactory()
    factory.dateAdded = Date.distantPast
    factory.user = profile
    factory.exercise = exercise

    let sessionFromDistantPast = factory.create()

    await factory.awaitPendingOperations()

    let results = await dataStore.exerciseSessionsCompletedSinceLastWeek(for: profile.userId)
    #expect(results.count == 2)
  }

  private func setupCurrentUser() async throws -> UserProfile {
    let factory = UserProfileFactory()
    let user = factory.create()
    await factory.awaitPendingOperations()
    return user
  }

  private func setupExercise() async throws -> Exercise {
    let factory = ExerciseFactory()
    let exercise = factory.create()
    await factory.awaitPendingOperations()
    return exercise
  }
}
