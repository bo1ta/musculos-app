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
  @Injected(\StorageContainer.ratingDataStore) private var dataStore: RatingDataStoreProtocol
  @Injected(\StorageContainer.userManager) private var userManager: UserSessionManagerProtocol
  @Injected(\NetworkContainer.ratingService) private var service: RatingServiceProtocol
  @Injected(\DataRepositoryContainer.backgroundWorker) private var backgroundWorker: BackgroundWorker

  public func getExerciseRatingsForCurrentUser() async throws -> [ExerciseRating] {
    guard let currentUserID = userManager.currentUserID else {
      throw MusculosError.notFound
    }

    guard self.isConnectedToInternet else {
      return await dataStore.getRatingsForUser(currentUserID)
    }

    let ratings = try await service.getExerciseRatingsForCurrentUser()
    backgroundWorker.queueOperation { [weak self] in
      try await self?.dataStore.importExerciseRatings(ratings)
    }
    return ratings
  }

  public func getUserRatingForExercise(_ exerciseID: UUID) async throws -> Double {
    let exerciseRatings = try await getExerciseRatingsForCurrentUser()
    return exerciseRatings.first(where: { $0.exerciseID == exerciseID })?.rating ?? 0.0
  }

  public func getRatingsForExercise(_ exerciseID: UUID) async throws -> [ExerciseRating] {
    guard self.isConnectedToInternet else {
      return await dataStore.getRatingsForExercise(exerciseID)
    }

    let ratings = try await service.getRatingsByExerciseID(exerciseID)
    backgroundWorker.queueOperation { [weak self] in
      try await self?.dataStore.importExerciseRatings(ratings)
    }
    return ratings
  }

  public func addRating(rating: Double, for exerciseID: UUID) async throws {
    guard let currentUserID = userManager.currentUserID else {
      throw MusculosError.notFound
    }
    
    let exerciseRating = ExerciseRating(exerciseID: exerciseID, userID: currentUserID, isPublic: true, rating: rating)

    try await dataStore.addExerciseRating(exerciseRating)
    try await service.addExerciseRating(exerciseRating)
  }
}
