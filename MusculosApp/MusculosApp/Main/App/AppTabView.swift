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
      HomeView()
        .tabItem {
          Label("Home", systemImage: "house")
        }
        .tag(0)

      ExploreExerciseView()
        .tabItem {
          Label("Explore", systemImage: "newspaper")
        }
        .tag(1)

      ProfileView()
        .tabItem {
          Label("Overview", systemImage: "person")
        }
        .tag(2)
    }
  }
}

#Preview {
  AppTabView()
}

