//
//  HomeDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import SwiftUI
import Models
import Navigator

public enum HomeDestinations {
  case addGoal
  case notifications
}

extension HomeDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case .addGoal:
      AddGoalSheet()
    case .notifications:
      EmptyView()
    }
  }

  public var method: NavigationMethod {
    switch self {
    case .addGoal:
        .sheet
    case .notifications:
        .push
    }
  }
}
