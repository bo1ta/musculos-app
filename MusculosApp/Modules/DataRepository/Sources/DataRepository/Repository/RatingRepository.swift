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
  @Injected(\StorageContainer.userDataStore) var userDataStore: UserDataStoreProtocol
  @Injected(\StorageContainer.exerciseDataStore) var exerciseDataStore: ExerciseDataStoreProtocol
  @Injected(\.backgroundWorker) var backgroundWorker: BackgroundWorker

  public func getExerciseRatingsForCurrentUser() async throws -> [ExerciseRating] {
    let userID = try requireCurrentUser()
    return try await fetch(
      forType: ExerciseRatingEntity.self,
      localTask: { await userDataStore.userProfileByID(userID)?.ratings ?? [] },
      remoteTask: { try await service.getExerciseRatingsForCurrentUser() })
  }

  public func getUserRatingForExercise(_ exerciseID: UUID) async throws -> Double {
    let exerciseRatings = try await getExerciseRatingsForCurrentUser()
    return exerciseRatings.first(where: { $0.exerciseID == exerciseID })?.rating ?? 0.0
  }

  public func getRatingsForExercise(_ exerciseID: UUID) async throws -> [ExerciseRating] {
    try await fetch(
      forType: ExerciseRatingEntity.self,
      localTask: { await exerciseDataStore.exerciseByID(exerciseID)?.ratings ?? [] },
      remoteTask: { try await service.getRatingsByExerciseID(exerciseID) })
  }

  public func addRating(rating: Double, for exerciseID: UUID) async throws {
    let userID = try requireCurrentUser()
    let exerciseRating = ExerciseRating(exerciseID: exerciseID, userID: userID, isPublic: true, rating: rating)

    try await update(
      localTask: { try await exerciseDataStore.addRating(exerciseRating) },
      remoteTask: { try await service.addExerciseRating(exerciseRating) })
  }
}
