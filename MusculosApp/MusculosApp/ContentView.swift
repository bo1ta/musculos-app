//
//  ContentView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.mainWindowSize) var windowSize
  
  @State private var selection: String = "workout"
  @State private var tabSelection: TabBarItem = .workout
  
  var body: some View {
    TabView {
      HomeView(challenge: MockConstants.challenge)
        .tabItem { Label("Home", systemImage: "house") }
      
      ExerciseFeedView()
        .tabItem { Label("Exercises", systemImage: "dumbbell") }
      
      ExerciseFeedView()
        .tabItem { Label("Profile", systemImage: "person") }
    }
    .onAppear(perform: setupTabBarAppearance)
  }
  
  func setupTabBarAppearance() {
    let bounds = CGRect(x: 0, y: 0, width: windowSize.width, height: 8)
    let gradientColors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.1).cgColor]
    guard
      let image = UIImage.gradientImageWithBounds(bounds: bounds, colors: gradientColors)
    else { return }
    
    let appearance = UITabBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = UIColor.systemGray6
    appearance.backgroundImage = UIImage()
    appearance.shadowImage = image
    
    UITabBar.appearance().standardAppearance = appearance
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
