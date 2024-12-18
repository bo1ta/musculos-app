//
//  RootTabView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import Navigator

enum RootTabs: String {
  case home
  case explore
  case history
  case profile
}

struct RootTabView: View {
  @SceneStorage("selectedTab") var selectedTab: RootTabs = .home

  var body: some View {
    TabView(selection: $selectedTab) {
      RootHomeScreen()
        .tabItem { Label("Home", systemImage: "house") }
        .tag(RootTabs.home)

      RootExploreScreen()
        .tabItem { Label("Explore", systemImage: "newspaper") }
        .tag(RootTabs.explore)

      RootHistoryScreen()
        .tabItem { Label("History", systemImage: "calendar.badge.clock") }
        .tag(RootTabs.history)

      RootProfileScreen()
        .tabItem { Label("Profile", systemImage: "person") }
        .tag(RootTabs.profile)
    }
    .onNavigationReceive { (tab: RootTabs, navigator) in
      navigator.dismissAll()
      selectedTab = tab
      return .auto
    }
  }
}

#Preview {
  RootTabView()
}

