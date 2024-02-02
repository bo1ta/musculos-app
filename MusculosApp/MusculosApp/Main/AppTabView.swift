//
//  AppTabView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import CoreData

struct AppTabView: View {
  @ObservedObject private var tabBarSettings = TabBarSettings()
  @State private var selection: String = "workout"
  @State private var tabSelection: TabBarItem = .dashboard
  
  var body: some View {
    CustomTabBarContainerView(selection: $tabSelection, tabBarItems: [.dashboard, .add, .workout]) {
      switch tabSelection {
      case .dashboard:
        HomeView(challenge: MockConstants.challenge)
      case .workout:
        ExerciseFeedView()
      case .add:
        DashboardView()
      }
    }
    .environmentObject(tabBarSettings)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AppTabView()
  }
}