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
    stubClient.expectedEndpoint = .exercises
    stubClient.expectedResponseData = try parseDataFromFile(name: "exercises")

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
    stubClient.expectedEndpoint = .favoriteExercise
    stubClient.expectedResponseData = try parseDataFromFile(name: "exercises")

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
    stubClient.expectedEndpoint = .exercisesByGoals
    stubClient.expectedQueryParams = [URLQueryItem(name: "goal", value: String(WorkoutGoal.flexibility.rawValue))]
    stubClient.expectedResponseData = try parseDataFromFile(name: "exercises")

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
    stubClient.expectedEndpoint = .exercisesByMuscle
    stubClient.expectedQueryParams = [URLQueryItem(name: "query", value: "chest")]
    stubClient.expectedResponseData = try parseDataFromFile(name: "exercises")

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
    stubClient.expectedEndpoint = .exerciseDetails(exerciseID)
    stubClient.expectedResponseData = try parseDataFromFile(name: "exerciseDetails")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = ExerciseService()
    let exercise = try await service.getExerciseDetails(for: exerciseID)
    #expect(exercise.isFavorite == true)
  }
}
