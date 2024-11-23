//
//  DataRepositoryContainer.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 18.10.2024.
//

import Factory
import Foundation

public final class DataRepositoryContainer: SharedContainer {
  nonisolated(unsafe) public static let shared = DataRepositoryContainer()

  public var manager = ContainerManager()
}

extension DataRepositoryContainer: AutoRegistering {
  public func autoRegister() {
    manager.defaultScope = .shared
  }
}

extension DataRepositoryContainer {
  public var userRepository: Factory<UserRepository> {
    self { UserRepository() }
  }

  public var exerciseRepository: Factory<ExerciseRepository> {
    self { ExerciseRepository() }
  }

  public var exerciseSessionRepository: Factory<ExerciseSessionRepository> {
    self { ExerciseSessionRepository() }
  }

  public var goalRepository: Factory<GoalRepository> {
    self { GoalRepository() }
  }

  public var ratingRepository: Factory<RatingRepository> {
    self { RatingRepository() }
  }

  internal var backgroundWorker: Factory<BackgroundWorker> {
    self { BackgroundWorker() }
      .singleton
  }
}
