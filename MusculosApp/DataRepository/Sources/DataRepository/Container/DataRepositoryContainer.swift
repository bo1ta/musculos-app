//
//  DataRepositoryContainer.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 18.10.2024.
//

import Factory
import Foundation

// MARK: - DataRepositoryContainer

public final class DataRepositoryContainer: SharedContainer {
  public static let shared = DataRepositoryContainer()

  public nonisolated(unsafe) var manager = ContainerManager()
}

// MARK: AutoRegistering

extension DataRepositoryContainer: AutoRegistering {
  public func autoRegister() {
    manager.defaultScope = .shared
  }
}

extension DataRepositoryContainer {
  public var userRepository: Factory<UserRepositoryProtocol> {
    self { UserRepository() }
  }

  public var userStore: Factory<UserStoreProtocol> {
    self { UserStore() }
      .cached
  }

  public var authenticationManager: Factory<AuthenticationManagerProtocol> {
    self { AuthenticationManager() }
      .singleton
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

  public var healthKitClient: Factory<HealthKitClient> {
    self { HealthKitClient() }
  }

  var backgroundWorker: Factory<BackgroundWorker> {
    self { BackgroundWorker() }
      .singleton
  }
}
