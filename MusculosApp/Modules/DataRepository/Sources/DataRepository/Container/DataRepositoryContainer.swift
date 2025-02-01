//
//  DataRepositoryContainer.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 18.10.2024.
//

import Factory
import Foundation
import Models

extension Container {
  var backgroundWorker: Factory<BackgroundWorker> {
    self { BackgroundWorker() }
      .shared
  }
}

// MARK: - DataRepositoryContainer

public final class DataRepositoryContainer: SharedContainer {
  public static let shared = DataRepositoryContainer()

  public nonisolated(unsafe) var manager = ContainerManager()
}

// MARK: AutoRegistering

extension DataRepositoryContainer {
  public var userRepository: Factory<UserRepositoryProtocol> {
    self { UserRepository() }
  }

  public var exerciseRepository: Factory<ExerciseRepositoryProtocol> {
    self { ExerciseRepository() }
  }

  public var exerciseSessionRepository: Factory<ExerciseSessionRepositoryProtocol> {
    self { ExerciseSessionRepository() }
  }

  public var goalRepository: Factory<GoalRepositoryProtocol> {
    self { GoalRepository() }
  }

  public var ratingRepository: Factory<RatingRepositoryProtocol> {
    self { RatingRepository() }
  }

  public var workoutRepository: Factory<WorkoutRepositoryProtocol> {
    self { WorkoutRepository() }
  }

  public var healthKitClient: Factory<HealthKitClient> {
    self { HealthKitClient() }
  }

  var backgroundWorker: Factory<BackgroundWorker> {
    self { BackgroundWorker() }
      .shared
  }
}
