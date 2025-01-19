//
//  RatingRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import Factory
import Foundation
import Models
import NetworkClient
import Storage
import Utility

// MARK: - RatingRepositoryProtocol

public protocol RatingRepositoryProtocol: Sendable {
  func getExerciseRatingsForCurrentUser() async throws -> [ExerciseRating]
  func getUserRatingForExercise(_ exerciseID: UUID) async throws -> Double
  func getRatingsForExercise(_ exerciseID: UUID) async throws -> [ExerciseRating]
  func addRating(rating: Double, for exerciseID: UUID) async throws
}

// MARK: - RatingRepository

public struct RatingRepository: @unchecked Sendable, BaseRepository, RatingRepositoryProtocol {
  @Injected(\NetworkContainer.ratingService) private var service: RatingServiceProtocol
  @Injected(\StorageContainer.coreDataStore) var dataStore: CoreDataStore

  public func getExerciseRatingsForCurrentUser() async throws -> [ExerciseRating] {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }

    guard isConnectedToInternet else {
      return await dataStore.userProfileByID(currentUserID)?.ratings ?? []
    }

    return try await fetchAndSync(
      remoteTask: { try await service.getExerciseRatingsForCurrentUser() },
      syncType: ExerciseRatingEntity.self)
  }

  public func getUserRatingForExercise(_ exerciseID: UUID) async throws -> Double {
    let exerciseRatings = try await getExerciseRatingsForCurrentUser()
    return exerciseRatings.first(where: { $0.exerciseID == exerciseID })?.rating ?? 0.0
  }

  public func getRatingsForExercise(_ exerciseID: UUID) async throws -> [ExerciseRating] {
    guard isConnectedToInternet else {
      return await dataStore.exerciseByID(exerciseID)?.ratings ?? []
    }
    return try await fetchAndSync(
      remoteTask: { try await service.getRatingsByExerciseID(exerciseID) },
      syncType: ExerciseRatingEntity.self)
  }

  public func addRating(rating: Double, for exerciseID: UUID) async throws {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }
    let exerciseRating = ExerciseRating(exerciseID: exerciseID, userID: currentUserID, isPublic: true, rating: rating)
    try await service.addExerciseRating(exerciseRating)
    syncStorage(exerciseRating, ofType: ExerciseRatingEntity.self)
  }
}
