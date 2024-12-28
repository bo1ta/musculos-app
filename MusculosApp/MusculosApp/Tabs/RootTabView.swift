//
//  RootTabView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import Components
import Navigator
import Utility

enum RootTabs: String {
  case home
  case explore
  case history
  case profile
}

struct RootTabView: View {
  @SceneStorage("selectedTab") var selectedTab: RootTabs = .home
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

      AddActionButton(action: { showActionSheet = true })
        .offset(y: -30)
        .opacity(showAddButton ? 1 : 0)
    }
    .onPreferenceChange(ShowTabPreferenceKey.self, perform: { value in
      showAddButton = value
    })
    .sheet(isPresented: $showActionSheet) {
      AddActionSheetContainer()
    }
  }
}

#Preview {
  RootTabView()
}

