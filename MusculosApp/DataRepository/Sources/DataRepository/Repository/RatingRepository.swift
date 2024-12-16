//
//  RatingRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import Foundation
import Models
import Utility
import Storage
import NetworkClient
import Factory

public actor RatingRepository: BaseRepository {
  @Injected(\NetworkContainer.ratingService) private var service: RatingServiceProtocol

  public func getExerciseRatingsForCurrentUser() async throws -> [ExerciseRating] {
    guard let currentUserID = self.currentUserID else {
      throw MusculosError.notFound
    }

    guard self.isConnectedToInternet else {
      return await coreDataStore.userProfile(for: currentUserID)?.ratings ?? []
    }

    let ratings = try await service.getExerciseRatingsForCurrentUser()
    syncStorage(ratings, of: ExerciseRatingEntity.self)
    return ratings
  }

  public func getUserRatingForExercise(_ exerciseID: UUID) async throws -> Double {
    let exerciseRatings = try await getExerciseRatingsForCurrentUser()
    return exerciseRatings.first(where: { $0.exerciseID == exerciseID })?.rating ?? 0.0
  }

  public func getRatingsForExercise(_ exerciseID: UUID) async throws -> [ExerciseRating] {
    guard self.isConnectedToInternet else {
      return await coreDataStore.exerciseByID(exerciseID)?.ratings ?? []
    }

    let ratings = try await service.getRatingsByExerciseID(exerciseID)
    syncStorage(ratings, of: ExerciseRatingEntity.self)
    return ratings
  }

  public func addRating(rating: Double, for exerciseID: UUID) async throws {
    guard let currentUserID = self.currentUserID else {
      throw MusculosError.notFound
    }
    
    let exerciseRating = ExerciseRating(exerciseID: exerciseID, userID: currentUserID, isPublic: true, rating: rating)
    try await coreDataStore.importModel(exerciseRating, of: ExerciseRatingEntity.self)
    try await service.addExerciseRating(exerciseRating)
  }
}
