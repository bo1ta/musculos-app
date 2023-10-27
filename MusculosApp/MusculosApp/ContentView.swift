//
//  ContentView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @State private var selection: String = "workout"
  @State private var tabSelection: TabBarItem = .workout

  var body: some View {
    TabView {
      HomeView(challenge: MockConstants.challenge)
        .tabItem { Label("Home", systemImage: "house") }
      
      WorkoutFeedView()
        .tabItem { Label("Explore", systemImage: "water.waves") }
    }
    
//    CustomTabBarContainerView(selection: $tabSelection) {
//      HomeView(challenge: MockConstants.challenge)
//        .tabBarItem(tab: .workout, selection: $tabSelection)
//
//      AddExerciseView()
//        .tabBarItem(tab: .add, selection: $tabSelection)
//    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
