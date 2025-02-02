//
//  ExerciseDataStoreTests.swift
//  Storage
//
//  Created by Solomon Alexandru on 02.02.2025.
//

import Factory
import Foundation
import Models
import Testing
@testable import Storage

@Suite(.serialized)
public class ExerciseDataStoreTests: MusculosTestBase {
  @Injected(\StorageContainer.exerciseDataStore) private var dataStore

  @Test
  func getExercises() async {
    let expectedExercise = ExerciseFactory.createExercise()
    let exercises = await dataStore.getExercises()
    #expect(exercises.first == expectedExercise)

    clearStorage()
  }

  @Test
  func getExercisesWithFetchLimit() async {
    _ = ExerciseFactory.createExercise()
    _ = ExerciseFactory.createExercise()
    _ = ExerciseFactory.createExercise()

    let exercises = await dataStore.getExercises(fetchLimit: 1)
    #expect(exercises.count == 1)

    clearStorage()
  }

  @Test
  func exerciseByID() async {
    let expectedExercise = ExerciseFactory.createExercise()
    let exercise = await dataStore.exerciseByID(expectedExercise.id)
    #expect(exercise == expectedExercise)

    clearStorage()
  }

  @Test
  func favoriteExercises() async {
    _ = ExerciseFactory.createExercise(isFavorite: true)
    _ = ExerciseFactory.createExercise()

    let favoriteExercises = await dataStore.favoriteExercises()
    #expect(favoriteExercises.count == 1)

    clearStorage()
  }

  @Test
  func exercisesByQuery() async {
    _ = ExerciseFactory.make { factory in
      factory.name = "Search query"
    }
    _ = ExerciseFactory.createExercise()

    let exercises = await dataStore.exercisesByQuery("Search query")
    #expect(exercises.count == 1)

    clearStorage()
  }

  @Test
  func exercisesForMuscles() async {
    let expectedMuscleTypes: [MuscleType] = [.glutes]
    _ = ExerciseFactory.make { factory in
      factory.primaryMuscles = expectedMuscleTypes.map { $0.rawValue }
    }
    _ = ExerciseFactory.createExercise()

    let exercises = await dataStore.exercisesForMuscles(expectedMuscleTypes)
    #expect(exercises.count == 1)

    clearStorage()
  }

  @Test
  func exercisesForGoal() async {
    let goal = GoalFactory.make { factory in
      factory.category = Goal.Category.loseWeight.rawValue
    }

    let expectedExercise = ExerciseFactory.make { factory in
      factory.category = ExerciseConstants.CategoryType.cardio.rawValue
    }

    let exercises = await dataStore.exercisesForGoal(goal)
    #expect(exercises.count == 1)
    #expect(exercises.first == expectedExercise)

    clearStorage()
  }

  @Test
  func exercisesForGoals() async {
    let loseWeightGoal = GoalFactory.make { factory in
      factory.category = Goal.Category.loseWeight.rawValue
    }
    let growMuscleGoal = GoalFactory.make { factory in
      factory.category = Goal.Category.growMuscle.rawValue
    }

    let _ = ExerciseFactory.make { factory in
      factory.category = ExerciseConstants.CategoryType.cardio.rawValue
    }
    let _ = ExerciseFactory.make { factory in
      factory.category = ExerciseConstants.CategoryType.strength.rawValue
    }
    let _ = ExerciseFactory.make { factory in
      factory.category = ExerciseConstants.CategoryType.plyometrics.rawValue
    }

    let exercises = await dataStore.exercisesForGoals([loseWeightGoal, growMuscleGoal], fetchLimit: 3)
    #expect(exercises.count == 2)

    clearStorage()
  }

  @Test
  func exercisesExcludingMuscles() async {
    let chestExercise = ExerciseFactory.make { factory in
      factory.primaryMuscles = [MuscleType.chest.rawValue]
    }
    let _ = ExerciseFactory.make { factory in
      factory.primaryMuscles = [MuscleType.biceps.rawValue]
    }

    let exercises = await dataStore.exercisesExcludingMuscles([.biceps])
    #expect(exercises.count == 1)
    #expect(exercises.first == chestExercise)

    clearStorage()
  }

  @Test
  func favoriteExercise() async throws {
    let exercise = ExerciseFactory.createExercise()
    #expect(exercise.isFavorite == false)

    try await dataStore.favoriteExercise(exercise, isFavorite: true)

    let updatedExercise = await dataStore.exerciseByID(exercise.id)
    #expect(updatedExercise?.isFavorite == true)

    clearStorage()
  }
}
