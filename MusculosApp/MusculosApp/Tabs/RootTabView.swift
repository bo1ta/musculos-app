//
//  RootTabView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import Components
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
      .onPreferenceChange(ShowTabPreferenceKey.self) { [$showAddButton] showButton in
        $showAddButton.wrappedValue = showButton
      }

      AddActionButton(action: { showActionSheet = true })
        .offset(y: -30)
        .opacity(showAddButton ? 1 : 0)
    }
    .sheet(isPresented: $showActionSheet) {
      AddActionSheetContainer()
    }
  }

  private func updateButtonVisibility(_ showButton: Bool) {
    showAddButton = showButton
  }
}

#Preview {
  RootTabView()
}
