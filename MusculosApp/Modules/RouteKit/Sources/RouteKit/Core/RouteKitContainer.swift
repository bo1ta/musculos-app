//
//  RouteKitContainer.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 06.01.2025.
//

import Factory

// MARK: - RouteKitContainer

public final class RouteKitContainer: SharedContainer {
  public static let shared = RouteKitContainer()

  public nonisolated(unsafe) var manager = ContainerManager()
}

extension RouteKitContainer {
  public var locationManager: Factory<LocationManager> {
    self { LocationManager() }
      .shared
  }

  public var mapKitClient: Factory<MapKitClient> {
    self { MapKitClient() }
      .shared
  }
}
