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
  @StateObject private var sheetCoordinator = SheetCoordinator<AddSheetEnum>()
  @State private var tabSelection: TabBarItem = .dashboard
  @State private var showSheet = false

  private let tabBarItems: [TabBarItem] = [.workout, .explore, .dashboard, .overview]
  
  var body: some View {
    CustomTabBarContainerView(selection: $tabSelection, tabBarItems: tabBarItems, onAddTapped: {
      showSheet.toggle()
    }) {
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
    .sheet(isPresented: $showSheet, content: {
      CreateItemSheetContainer()
    })
    .environmentObject(tabBarSettings)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AppTabView().environmentObject(UserStore())
  }
}
