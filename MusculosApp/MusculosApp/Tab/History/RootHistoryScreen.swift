//
//  RootHistoryScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import SwiftUI
import Navigator

struct RootHistoryScreen: View {
  var body: some View {
    ManagedNavigationStack(scene: "history") {
      HistoryScreen()
        .navigationCheckpoint(.history)
        .navigationDestination(HistoryDestinations.self)
    }
  }
}

extension NavigationCheckpoint {
  nonisolated(unsafe) static let history: NavigationCheckpoint = "history"
}
