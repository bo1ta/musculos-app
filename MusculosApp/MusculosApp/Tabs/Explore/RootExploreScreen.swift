//
//  RootExploreScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Navigator
import SwiftUI

// MARK: - RootExploreScreen

struct RootExploreScreen: View {
  var body: some View {
    ManagedNavigationStack(scene: "explore") {
      ExploreScreen()
        .navigationCheckpoint(.explore)
        .navigationDestination(ExploreDestinations.self)
        .navigationDestination(CommonDestinations.self)
    }
  }
}

extension NavigationCheckpoint {
  static let explore: NavigationCheckpoint = "explore"
}
