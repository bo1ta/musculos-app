//
//  AppTabView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import CoreData
import Utility

struct AppTabView: View {
  @Environment(\.navigationRouter) private var navigationRouter

  @State private var selectedTab: TabBarItem = .home
  @State private var showingSheet = false
  
  private let tabBarItems: [TabBarItem] = [.home, .explore, .overview]

  var body: some View {
    CustomTabBarContainerView(
      selection: $selectedTab,
      tabBarItems: tabBarItems,
      onAddTapped: showAddActionSheet
    ) {
      selectedTabView
        .modifier(KeyboardDismissableViewModifier())
    }
  }

  @ViewBuilder
  private var selectedTabView: some View {
    switch selectedTab {
    case .home:
      HomeView()
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
