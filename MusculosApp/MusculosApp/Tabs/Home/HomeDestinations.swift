//
//  HomeDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Models
import Navigator
import SwiftUI

public enum HomeDestinations {
  case addGoal
  case notifications
  case liveRoute
}

extension HomeDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case .addGoal:
      AddGoalSheet()
    case .notifications:
      LiveRouteScreen()
    case .liveRoute:
      LiveRouteScreen()
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
