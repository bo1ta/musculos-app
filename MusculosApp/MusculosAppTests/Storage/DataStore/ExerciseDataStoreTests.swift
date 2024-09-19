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

@Suite
public struct ExerciseDataStoreTests {
  @Injected(\StorageContainer.exerciseDataStore) private var dataStore

  @Test func getAllIsInitiallyEmpty() async throws {
    let exercises = await dataStore.getAll(fetchLimit: 10)
    #expect(exercises.isEmpty)
  }

  @Test func addExercise() async throws {
    let exercise = ExerciseFactory.createExercise(name: "First Exercise")
    try await dataStore.add(exercise)
    let exercises = await dataStore.getAll(fetchLimit: 10)
    #expect(exercises.contains(exercise))
  }

  @Test func isFavorite() async throws {
    let exercise = ExerciseFactory.createExercise(name: "First Exercise")
    try await dataStore.add(exercise)

    await #expect(dataStore.isFavorite(exercise) == false)

    try await dataStore.setIsFavorite(exercise, isFavorite: true)

    await #expect(dataStore.isFavorite(exercise) == true)
  }

  @Test func getByName() async throws {
    let exercise = ExerciseFactory.createExercise(name: "First Exercise")
    try await dataStore.add(exercise)
    
    let fetchedExercises = await dataStore.getByName(exercise.name)
    #expect(fetchedExercises.contains(exercise))
  }

  @Test func getByMuscles() async throws {
    let exercise = ExerciseFactory.createExercise(
      name: "First Exercise",
      primaryMuscles: [MuscleType.chest.rawValue]
    )
    try await dataStore.add(exercise)
    
    let fetchedExercises = await dataStore.getByMuscles([.chest])
    #expect(fetchedExercises.contains(exercise))
  }
}
