//
//  RootHistoryScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
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
