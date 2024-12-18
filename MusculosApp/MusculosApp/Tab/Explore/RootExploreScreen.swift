//
//  RootExploreScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import SwiftUI
import Navigator

struct RootExploreScreen: View {
  var body: some View {
    ManagedNavigationStack(scene: "explore") {
      ExploreScreen()
        .navigationCheckpoint(.home)
        .navigationDestination(ExploreDestinations.self)
        .navigationDestination(CommonDestinations.self)
    }
  }
}

extension NavigationCheckpoint {
  nonisolated(unsafe) static let explore: NavigationCheckpoint = "explore"
}
