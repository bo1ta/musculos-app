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

      RunTrackerScreen()
        .tabItem {
          Label("Run Tracker", systemImage: "figure.run")
        }
        .tag(1)


      ExploreScreen()
        .tabItem {
          Label("Explore", systemImage: "newspaper")
        }
        .tag(2)

      HistoryScreen()
        .tabItem {
          Label("History", systemImage: "calendar.badge.clock")
        }
        .tag(3)

      ProfileScreen()
        .tabItem {
          Label("Profile", systemImage: "person")
        }
        .tag(4)
    }
  }
}

#Preview {
  AppTabView()
}

