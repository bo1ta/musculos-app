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
  case routePlanner
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
          .toolbarBackground(.white, for: .tabBar)
          .toolbarBackground(.visible, for: .tabBar)
          .onPreferenceChange(ShowTabPreferenceKey.self) { [$showAddButton] showTabBar in
            $showAddButton.wrappedValue = showTabBar
          }

        RootExploreScreen()
          .tabItem { Label("Explore", systemImage: "newspaper") }
          .tag(RootTabs.explore)
          .toolbarBackground(.white, for: .tabBar)
          .toolbarBackground(.visible, for: .tabBar)
          .onPreferenceChange(ShowTabPreferenceKey.self) { [$showAddButton] showTabBar in
            $showAddButton.wrappedValue = showTabBar
          }

        RootRoutePlannerScreen()
          .tabItem { Label("Run", systemImage: "figure.run") }
          .tag(RootTabs.routePlanner)
          .toolbarBackground(.white, for: .tabBar)
          .toolbarBackground(.visible, for: .tabBar)
          .preference(key: ShowTabPreferenceKey.self, value: false)

        RootProfileScreen()
          .tabItem { Label("Profile", systemImage: "person") }
          .tag(RootTabs.profile)
          .toolbarBackground(.white, for: .tabBar)
          .toolbarBackground(.visible, for: .tabBar)
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
