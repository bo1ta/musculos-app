//
//  RootHistoryScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.01.2025.
//

import Navigator
import SwiftUI

// MARK: - RootHistoryScreen

struct RootHistoryScreen: View {
  var body: some View {
    ManagedNavigationStack(scene: "history") {
      HistoryScreen()
        .navigationCheckpoint(.history)
        .navigationDestination(CommonDestinations.self)
    }
  }
}

extension NavigationCheckpoint {
  static let history: NavigationCheckpoint = "history"
}
