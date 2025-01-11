//
//  HomeDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Models
import Navigator
import RouteKit
import SwiftUI

// MARK: - HomeDestinations

public enum HomeDestinations {
  case addGoal
  case notifications
  case liveRoute
}

// MARK: NavigationDestination

extension HomeDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case .addGoal:
      AddGoalSheet(onBack: { })

    case .notifications:
      RoutePlannerScreen()

    case .liveRoute:
      RoutePlannerScreen()
    }
  }

  public var method: NavigationMethod {
    switch self {
    case .addGoal:
      .sheet
    case .notifications:
      .push
    case .liveRoute:
      .push
    }
  }
}
