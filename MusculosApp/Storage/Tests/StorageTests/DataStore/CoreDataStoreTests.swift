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
    let exercise = ExerciseFactory.createExercise()

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

    let fetchedExercises = await dataStore.exercisesForMuscles([.chest])
    let firstExercise = try #require(fetchedExercises.first(where: { $0.id == exercise.id }))
    #expect(firstExercise.name == exercise.name)
  }

  @Test
  func getCompletedSinceLastWeek() async throws {
    let exercise = ExerciseFactory.createExercise()
    let profile = UserProfileFactory.createUser()

    var factory = ExerciseSessionFactory()
    factory.user = profile
    factory.exercise = exercise
    _ = factory.create()

    factory = ExerciseSessionFactory()
    factory.user = profile
    factory.exercise = exercise
    factory.dateAdded = try #require(Calendar.current.date(byAdding: .day, value: -2, to: Date()))
    _ = factory.create()

    factory = ExerciseSessionFactory()
    factory.dateAdded = Date.distantPast
    factory.user = profile
    factory.exercise = exercise
    _ = factory.create()

    let results = await dataStore.exerciseSessionsCompletedSinceLastWeek(for: profile.userId)
    #expect(results.count == 2)
  }
}
