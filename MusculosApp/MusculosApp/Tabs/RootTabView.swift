//
//  RootTabView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import Components
import Factory
import Navigator
import SwiftUI
import Utility

// MARK: - RootTabs

enum RootTabs: String {
  case home
  case explore
  case history
  case profile
}

// MARK: - RootTabView

struct RootTabView: View {
  @SceneStorage("selectedTab") var selectedTab = RootTabs.home

  var body: some View {
    ZStack(alignment: .bottom) {
      TabView(selection: $selectedTab) {
        RootHomeScreen()
          .tabItem { Label("Home", systemImage: "house") }
          .tag(RootTabs.home)
          .toolbarBackground(.white, for: .tabBar)
          .toolbarBackground(.visible, for: .tabBar)

        RootExploreScreen()
          .tabItem { Label("Explore", systemImage: "newspaper") }
          .tag(RootTabs.explore)
          .toolbarBackground(.white, for: .tabBar)
          .toolbarBackground(.visible, for: .tabBar)

        RootHistoryScreen()
          .tabItem { Label("History", systemImage: "calendar") }
          .tag(RootTabs.history)
          .toolbarBackground(.white, for: .tabBar)
          .toolbarBackground(.visible, for: .tabBar)

        RootProfileScreen()
          .tabItem { Label("Profile", systemImage: "person") }
          .tag(RootTabs.profile)
          .toolbarBackground(.white, for: .tabBar)
          .toolbarBackground(.visible, for: .tabBar)
      }
      .onNavigationReceive { (tab: RootTabs, navigator) in
        _ = try? navigator.dismissAll()
        selectedTab = tab
        return .auto
      }
    }
  }
}

#Preview {
  RootTabView()
}
