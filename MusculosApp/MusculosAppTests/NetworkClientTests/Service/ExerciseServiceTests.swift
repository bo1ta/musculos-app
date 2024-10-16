//
//  ExerciseServiceTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.10.2024.
//

import Testing
import Foundation
import Factory

@testable import NetworkClient
@testable import Models
@testable import Utility

@Suite(.serialized)
final class ExerciseServiceTests: MusculosTestBase {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  @Test func getExercises() async throws {
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .get
    stubClient.expectedPath = .exercises
    stubClient.expectedData = try readFromFile(name: "exercises")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = ExerciseService()
    let exercises = try await service.getExercises()
    #expect(exercises.count == 20)
  }

  @Test func getFavoriteExercises() async throws {
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .get
    stubClient.expectedPath = .favoriteExercise
    stubClient.expectedData = try readFromFile(name: "exercises")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = ExerciseService()
    let exercises = try await service.getFavoriteExercises()
    #expect(exercises.count == 20)
  }

  @Test func getByWorkoutGoal() async throws {
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .get
    stubClient.expectedPath = .exercisesByGoals
    stubClient.expectedQueryParams = [URLQueryItem(name: "goal", value: String(WorkoutGoal.flexibility.rawValue))]
    stubClient.expectedData = try readFromFile(name: "exercises")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = ExerciseService()
    let exercises = try await service.getByWorkoutGoal(WorkoutGoal.flexibility)
    #expect(exercises.count == 20)
  }

  @Test func searchByMuscleQuery() async throws {
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .get
    stubClient.expectedPath = .exercisesByMuscle
    stubClient.expectedQueryParams = [URLQueryItem(name: "query", value: "chest")]
    stubClient.expectedData = try readFromFile(name: "exercises")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = ExerciseService()
    let exercises = try await service.searchByMuscleQuery("chest")
    #expect(exercises.count == 20)
  }

  @Test func getExerciseDetails() async throws {
    let exerciseID = UUID()

    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .get
    stubClient.expectedPath = .exerciseDetails(exerciseID)
    stubClient.expectedData = try readFromFile(name: "exerciseDetails")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = ExerciseService()
    let exercise = try await service.getExerciseDetails(for: exerciseID)
    #expect(exercise.isFavorite == true)
  }
}
