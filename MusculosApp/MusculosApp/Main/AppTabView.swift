//
//  AppTabView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI

struct AppTabView: View {
  var body: some View {
    TabView {
      HomeScreen()
        .tabItem {
          Label("Home", systemImage: "house")
        }
        .tag(0)

      ExploreScreen()
        .tabItem {
          Label("Explore", systemImage: "newspaper")
        }
        .tag(1)

      HistoryScreen()
        .tabItem {
          Label("History", systemImage: "calendar.badge.clock")
        }
        .tag(2)

      ProfileScreen()
        .tabItem {
          Label("Overview", systemImage: "person")
        }
        .tag(3)
    }
  }
}

#Preview {
  AppTabView()
}

