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
  
  @State private var tabSelection: TabBarItem = .explore
  @State private var showingSheet = false

  private let tabBarItems: [TabBarItem] = [.explore, .overview]
  
  var body: some View {
    CustomTabBarContainerView(selection: $tabSelection,
                              tabBarItems: tabBarItems,
                              onAddTapped: showSheet) {
      tabSelection.view
    }
    .sheet(isPresented: $showingSheet) {
      AddActionSheetContainer()
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
    AppTabView().environmentObject(UserStore()).environmentObject(ExerciseStore())
  }
}
