//
//  AppTabView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import CoreData

struct AppTabView: View {
  @Environment(\.navigationRouter) private var navigationRouter

  @State private var appManager = AppManager()
  
  @State private var tabSelection: TabBarItem = .explore
  @State private var showingSheet = false
  
  private let tabBarItems: [TabBarItem] = [.explore, .overview]
  
  var body: some View {
    CustomTabBarContainerView(
      selection: $tabSelection,
      tabBarItems: tabBarItems,
      onAddTapped: {
        navigationRouter.present(.addActionSheet)
      }
    ) {
      tabSelection.view
    }
    .toastView(toast: $appManager.toast)
    .environment(\.appManager, appManager)
  }
  
  @MainActor
  private func showSheet() {
    showingSheet.toggle()
  }
}

#Preview {
  AppTabView()
}
