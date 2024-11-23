//
//  RatingDataStore.swift
//  Storage
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import Foundation
import CoreData
import Models
import Utility

public protocol RatingDataStoreProtocol: BaseDataStore, Sendable {
  func getRatingsForExercise(_ exerciseID: UUID) async -> [ExerciseRating]
  func getRatingsForUser(_ userID: UUID) async -> [ExerciseRating]
  func addExerciseRating(_ exerciseRating: ExerciseRating) async throws
  func importExerciseRatings(_ exerciseRatings: [ExerciseRating]) async throws
}

public struct RatingDataStore: RatingDataStoreProtocol {
  public init() { }

  public func getRatingsForUser(_ userID: UUID) async -> [ExerciseRating] {
    return await storageManager.performRead { storage in
      guard let user = storage.firstObject(of: UserProfileEntity.self, matching: PredicateProvider.userProfileById(userID)) else {
        return []
      }
      return user.exerciseRatings.map { $0.toReadOnly() }
    }
  }

  public func getRatingsForExercise(_ exerciseID: UUID) async -> [ExerciseRating] {
    return await storageManager.performRead { storage in
      guard let exercise = storage.firstObject(of: ExerciseEntity.self, matching: PredicateProvider.exerciseById(exerciseID)) else {
        return []
      }
      return exercise.exerciseRatings.map { $0.toReadOnly() }
    }
  }

  public func addExerciseRating(_ exerciseRating: ExerciseRating) async throws {
    return try await storageManager.performWrite { storage in
      let entity = storage.findOrInsert(
        of: ExerciseRatingEntity.self,
        using: PredicateProvider.exerciseRatingByID(exerciseRating.ratingID)
      )
      entity.populateEntityFrom(exerciseRating, using: storage)
    }
  }

  public func importExerciseRatings(_ exerciseRatings: [ExerciseRating]) async throws {
    return try await self.importToStorage(models: exerciseRatings, localObjectType: ExerciseRatingEntity.self)
  }
}
