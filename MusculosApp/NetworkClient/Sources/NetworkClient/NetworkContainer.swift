//
//  NetworkContainer.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 17.09.2024.
//

import Factory
import Utility

public final class NetworkContainer: SharedContainer {
  nonisolated(unsafe) public static let shared = NetworkContainer()
  public var manager = ContainerManager()
}

extension NetworkContainer {
  public var client: Factory<MusculosClientProtocol> {
    self {
      MusculosClient(
        requestMiddlewares: [
          ConnectivityMiddleware(),
          AuthorizationMiddleware(),
          RetryMiddleware()
        ],
        responseMiddlewares: [
          AuthCheckerMiddleware(),
          LoggingMiddleware()
        ]
      )
    }
    .cached
  }

  internal var offlineRequestManager: Factory<OfflineRequestManager> {
    self { OfflineRequestManager() }
      .singleton
  }

  public var userService: Factory<UserServiceProtocol> {
    self { UserService() }
  }

  public var exerciseService: Factory<ExerciseServiceProtocol> {
    self { ExerciseService() }
  }

  public var exerciseSessionService: Factory<ExerciseSessionServiceProtocol> {
    self { ExerciseSessionService() }
  }

  public var goalService: Factory<GoalServiceProtocol> {
    self { GoalService() }
  }

  public var ratingService: Factory<RatingServiceProtocol> {
    self { RatingService() }
  }

  public var networkMonitor: Factory<NetworkMonitorProtocol> {
    self { NetworkMonitor() }
      .singleton
  }
}

