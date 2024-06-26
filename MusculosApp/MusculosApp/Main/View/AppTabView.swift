//
//  AppTabView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import CoreData

struct AppTabView: View {
  @State private var appManager = AppManager()
  
  @State private var tabSelection: TabBarItem = .explore
  @State private var showingSheet = false
  
  private let tabBarItems: [TabBarItem] = [.explore, .overview]
  
  var body: some View {
    CustomTabBarContainerView(
      selection: $tabSelection,
      tabBarItems: tabBarItems,
      onAddTapped: showSheet
    ) {
      tabSelection.view
    }
    .sheet(isPresented: $showingSheet) {
      AddActionSheetContainer()
    }
    .toastView(toast: $appManager.toast)
    .environment(\.appManager, appManager)
  }
  
  @MainActor
  private func showSheet() {
    showingSheet.toggle()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AppTabView()
  }
}
