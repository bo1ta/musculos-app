//
//  AppTabView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import CoreData

struct AppTabView: View {  
  @StateObject private var tabBarSettings = TabBarSettings()
  @State private var tabSelection: TabBarItem = .overview
  
  private let tabBarItems: [TabBarItem] = [.overview, .workout, .profile]
  
  var body: some View {
    CustomTabBarContainerView(selection: $tabSelection, tabBarItems: tabBarItems) {
      switch tabSelection {
      case .overview:
        OverviewView()
      case .workout:
        DashboardView()
      case .profile:
        ProfileView()
      }
    }
    .environmentObject(tabBarSettings)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AppTabView().environmentObject(UserStore())
  }
}
