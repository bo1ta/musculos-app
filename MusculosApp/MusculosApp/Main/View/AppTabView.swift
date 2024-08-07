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

  @State private var selectedTab: TabBarItem = .explore
  @State private var showingSheet = false
  
  private let tabBarItems: [TabBarItem] = [.explore, .overview]
  
  var body: some View {
    CustomTabBarContainerView(
      selection: $selectedTab,
      tabBarItems: tabBarItems,
      onAddTapped: showAddActionSheet
    ) {
      currentTab
    }
  }

  @ViewBuilder
  private var currentTab: some View {
    switch selectedTab {
    case .explore:
      ExploreExerciseView()
    case .overview:
      OverviewView()
    case .workout:
      WorkoutListView()
    }
  }

  @MainActor
  private func showSheet() {
    showingSheet.toggle()
  }

  private func showAddActionSheet() {
    navigationRouter.present(.addActionSheet)
  }
}

#Preview {
  AppTabView()
}
