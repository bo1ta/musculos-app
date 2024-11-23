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
  @Injected(\StorageContainer.ratingDataStore) private var ratingDataStore: RatingDataStoreProtocol
  @Injected(\StorageContainer.userManager) private var userManager: UserSessionManagerProtocol
  @Injected(\NetworkContainer.ratingService) private var ratingService: RatingServiceProtocol
  @Injected(\DataRepositoryContainer.backgroundWorker) private var backgroundWorker: BackgroundWorker

//  public func getExerciseRatingsForCurrentUser() async throws -> [ExerciseRating] {
//    guard let currentUserID = userManager.currentUserID else {
//      throw MusculosError.notFound
//    }
//
//    return
//
//  }
}
