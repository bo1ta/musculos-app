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

  @State private var showActionSheet = false
  @State private var showAddButton = true

  var body: some View {
    ZStack(alignment: .bottom) {
      TabView(selection: $selectedTab) {
        RootHomeScreen()
          .tabItem { Label("Home", systemImage: "house") }
          .tag(RootTabs.home)
          .onPreferenceChange(ShowTabPreferenceKey.self) { [$showAddButton] showTabBar in
            $showAddButton.wrappedValue = showTabBar
          }

        RootExploreScreen()
          .tabItem { Label("Explore", systemImage: "newspaper") }
          .tag(RootTabs.explore)
          .onPreferenceChange(ShowTabPreferenceKey.self) { [$showAddButton] showTabBar in
            $showAddButton.wrappedValue = showTabBar
          }

        RootHistoryScreen()
          .tabItem { Label("History", systemImage: "calendar.badge.clock") }
          .tag(RootTabs.history)

        RootProfileScreen()
          .tabItem { Label("Profile", systemImage: "person") }
          .tag(RootTabs.profile)
          .onPreferenceChange(ShowTabPreferenceKey.self) { [$showAddButton] showTabBar in
            $showAddButton.wrappedValue = showTabBar
          }
      }
      .onNavigationReceive { (tab: RootTabs, navigator) in
        _ = try? navigator.dismissAll()
        selectedTab = tab
        return .auto
      }

      AddActionButton(action: { showActionSheet = true })
        .offset(y: -30)
        .opacity(showAddButton ? 1 : 0)
    }
    .sheet(isPresented: $showActionSheet) {
      AddActionSheetContainer()
    }
  }
}

#Preview {
  RootTabView()
}
