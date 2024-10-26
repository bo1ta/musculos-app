//
//  ExerciseService.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.01.2024.
//

import Foundation
import Models
import Factory

public protocol ExerciseServiceProtocol: Sendable {
  func getExercises() async throws -> [Exercise]
  func searchByMuscleQuery(_ query: String) async throws -> [Exercise]
  func getExerciseDetails(for exerciseID: UUID) async throws -> Exercise
  func getFavoriteExercises() async throws -> [Exercise]
  func setFavoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws
  func getByWorkoutGoal(_ workoutGoal: WorkoutGoal) async throws -> [Exercise]
}

public struct ExerciseService: ExerciseServiceProtocol, @unchecked Sendable {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  public func getExercises() async throws -> [Exercise] {
    let request = APIRequest(method: .get, endpoint: .exercises(.index))

    let data = try await client.dispatch(request)
    return try Exercise.createArrayFrom(data)
  }
  
  public func searchByMuscleQuery(_ query: String) async throws -> [Exercise] {
    return []
  }

  public func getExerciseDetails(for exerciseID: UUID) async throws -> Exercise {
    let request = APIRequest(method: .get, endpoint: .exercises(.exerciseDetails(exerciseID)))

    let data = try await client.dispatch(request)
    return try Exercise.createFrom(data)
  }

  public func getFavoriteExercises() async throws -> [Exercise] {
    let request = APIRequest(method: .get, endpoint: .exercises(.favoriteExercises))

    let data = try await client.dispatch(request)
    return try Exercise.createArrayFrom(data)
  }

  public func setFavoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws {
    var request = APIRequest(method: .post, endpoint: .exercises(.favoriteExercises))
    request.body = [
      "exercise_id": exercise.id.uuidString,
      "is_favorite": isFavorite
    ]

    _ = try await client.dispatch(request)
  }

  public func getByWorkoutGoal(_ workoutGoal: WorkoutGoal) async throws -> [Exercise] {
    var request = APIRequest(method: .get, endpoint: .exercises(.exercisesByGoals))
    request.queryParams = [
      URLQueryItem(name: "goal", value: String(workoutGoal.rawValue))
    ]

    let data = try await client.dispatch(request)
    return try Exercise.createArrayFrom(data)
  }
}
