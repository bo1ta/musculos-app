//
//  RootHomeScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import SwiftUI
import Navigator

struct RootHomeScreen: View {
  var body: some View {
    ManagedNavigationStack(scene: "home") {
      HomeScreen()
        .navigationCheckpoint(.home)
        .navigationDestination(HomeDestinations.self)
        .navigationDestination(CommonDestinations.self)
    }
  }
}

extension NavigationCheckpoint {
  nonisolated(unsafe) static let home: NavigationCheckpoint = "home"
}
