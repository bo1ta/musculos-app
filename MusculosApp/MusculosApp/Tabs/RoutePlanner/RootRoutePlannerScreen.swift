//
//  Run.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.01.2025.
//

import Navigator
import RouteKit
import SwiftUI

// MARK: - RootRoutePlannerScreen

struct RootRoutePlannerScreen: View {
  var body: some View {
    ManagedNavigationStack(scene: "routePlanner") {
      RoutePlannerScreen()
        .navigationCheckpoint(.routePlanner)
    }
  }
}

extension NavigationCheckpoint {
  static let routePlanner: NavigationCheckpoint = "routePlanner"
}
