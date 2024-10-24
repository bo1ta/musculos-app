//
//  ExerciseDataStoreTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.09.2024.
//

import Testing
import Factory
import Models
import Foundation
@testable import Storage

@Suite(.serialized)
public class ExerciseDataStoreTests: MusculosTestBase {

  @Test func getAllIsInitiallyEmpty() async throws {
    let dataStore = ExerciseDataStore()

    let exercises = await dataStore.getAll(fetchLimit: 10)
    #expect(exercises.isEmpty)
  }

  @Test func addExercise() async throws {
    defer { clearStorage() }

    let dataStore = ExerciseDataStore()

    let exercise = ExerciseFactory.createExercise(name: "First Exercise")
    try await dataStore.add(exercise)

    let exercises = await dataStore.getAll(fetchLimit: 10)
    #expect(exercises.contains(exercise))
  }

  @Test func isFavorite() async throws {
    defer { clearStorage() }

    let dataStore = ExerciseDataStore()

    let exercise = ExerciseFactory.createExercise(name: "First Exercise")
    try await dataStore.add(exercise)

    await #expect(dataStore.isFavorite(exercise) == false)

    try await dataStore.setIsFavorite(exercise, isFavorite: true)

    try await Task.sleep(for: .seconds(0.1))
    await #expect(dataStore.isFavorite(exercise) == true)
  }

  @Test func getByName() async throws {
    defer { clearStorage() }

    let dataStore = ExerciseDataStore()

    let exercise = ExerciseFactory.createExercise(name: "First Exercise")
    try await dataStore.add(exercise)

    let fetchedExercises = await dataStore.getByName(exercise.name)
    #expect(fetchedExercises.contains(exercise))
  }

  @Test func getByMuscles() async throws {
    defer { clearStorage() }

    let dataStore = ExerciseDataStore()

    let exercise = ExerciseFactory.createExercise(
      name: "First Exercise",
      primaryMuscles: [MuscleType.chest.rawValue]
    )
    try await dataStore.add(exercise)

    let fetchedExercises = await dataStore.getByMuscles([.chest])
    let firstExercise = try #require(fetchedExercises.first(where: { $0.id == exercise.id }))
    #expect(firstExercise.name == exercise.name)
  }
}
