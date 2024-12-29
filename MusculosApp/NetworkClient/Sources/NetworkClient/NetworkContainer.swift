//
//  NetworkContainer.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 17.09.2024.
//

import Factory
import Utility

public final class NetworkContainer: SharedContainer {
  public static let shared = NetworkContainer()

  public nonisolated(unsafe) var manager = ContainerManager()
}

public extension NetworkContainer {
  var client: Factory<MusculosClientProtocol> {
    self {
      MusculosClient(
        requestMiddlewares: [
          ConnectivityMiddleware(),
          AuthorizationMiddleware(),
          RetryMiddleware(),
        ],
        responseMiddlewares: [
          AuthCheckerMiddleware(),
          LoggingMiddleware(),
        ]
      )
    }
    .cached
  }

  var networkMonitor: Factory<NetworkMonitorProtocol> {
    self { NetworkMonitor() }
      .singleton
  }

  internal var offlineRequestManager: Factory<OfflineRequestManager> {
    self { OfflineRequestManager() }
      .singleton
  }

  var userService: Factory<UserServiceProtocol> {
    self { UserService() }
  }

  var exerciseService: Factory<ExerciseServiceProtocol> {
    self { ExerciseService() }
  }

  var exerciseSessionService: Factory<ExerciseSessionServiceProtocol> {
    self { ExerciseSessionService() }
  }

  var goalService: Factory<GoalServiceProtocol> {
    self { GoalService() }
  }

  var ratingService: Factory<RatingServiceProtocol> {
    self { RatingService() }
  }

  var imageService: Factory<ImageServiceProtocol> {
    self { ImageService() }
  }
}
