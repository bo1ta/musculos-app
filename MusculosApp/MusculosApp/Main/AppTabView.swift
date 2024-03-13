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
  
  @State private var tabSelection: TabBarItem = .dashboard
  @State private var showingSheet = false

  private let tabBarItems: [TabBarItem] = [.workout, .explore, .dashboard, .overview]
  
  var body: some View {
    CustomTabBarContainerView(selection: $tabSelection,
                              tabBarItems: tabBarItems,
                              onAddTapped: showSheet) {
      switch tabSelection {
      case .workout:
        WorkoutView()
      case .dashboard:
        DashboardView()
      case .explore:
        ExploreExerciseView()
      case .overview:
        OverviewView()
      }
    }
    .sheet(isPresented: $showingSheet) {
      CreateItemSheetContainer()
    }
    .environmentObject(tabBarSettings)
  }
  
  @MainActor
  private func showSheet() {
    showingSheet.toggle()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AppTabView().environmentObject(UserStore())
  }
}
