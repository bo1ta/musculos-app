//
//  RootProfileScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Navigator
import SwiftUI

struct RootProfileScreen: View {
  var body: some View {
    ManagedNavigationStack(scene: "profile") {
      ProfileScreen()
        .navigationCheckpoint(.profile)
        .navigationDestination(CommonDestinations.self)
    }
  }
}

extension NavigationCheckpoint {
  nonisolated(unsafe) static let profile: NavigationCheckpoint = "profile"
}
