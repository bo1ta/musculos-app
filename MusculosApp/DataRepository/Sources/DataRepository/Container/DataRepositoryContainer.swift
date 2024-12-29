//
//  DataRepositoryContainer.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 18.10.2024.
//

import Factory
import Foundation

public final class DataRepositoryContainer: SharedContainer {
  public nonisolated(unsafe) static let shared = DataRepositoryContainer()

  public var manager = ContainerManager()
}

extension DataRepositoryContainer: AutoRegistering {
  public func autoRegister() {
    manager.defaultScope = .shared
  }
}

public extension DataRepositoryContainer {
  var userRepository: Factory<UserRepository> {
    self { UserRepository() }
  }

  var exerciseRepository: Factory<ExerciseRepository> {
    self { ExerciseRepository() }
  }

  var exerciseSessionRepository: Factory<ExerciseSessionRepository> {
    self { ExerciseSessionRepository() }
  }

  var goalRepository: Factory<GoalRepository> {
    self { GoalRepository() }
  }

  var ratingRepository: Factory<RatingRepository> {
    self { RatingRepository() }
  }

  var healthKitClient: Factory<HealthKitClient> {
    self { HealthKitClient() }
  }

  internal var backgroundWorker: Factory<BackgroundWorker> {
    self { BackgroundWorker() }
      .singleton
  }
}
