//
//  HomeView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.09.2024.
//

import SwiftUI
import Models
import Components

struct HomeView: View {
  @Environment(\.userStore) private var userStore
  @Environment(\.navigationRouter) private var navigationRouter

  @State private var viewModel = HomeViewModel()

  var body: some View {
    VStack {
      GreetingHeader(
        profile: viewModel.currentUser,
        onSearchTap: {
          navigateTo(.search)
        },
        onNotificationsTap: {
          navigateTo(.notifications)
        }
      )
      .padding(.horizontal, 10)

      Spacer()
    }
    .task {
      await viewModel.fetchData()
    }
  }
}

// MARK: - Navigation handling

extension HomeView {
  enum NavigationDestination {
    case search
    case notifications
    case filteredByGoal(Goal)
  }

  private func navigateTo(_ destination: NavigationDestination) {
    switch destination {
    case .search:
      navigationRouter.push(.search)
    case .notifications:
      navigationRouter.push(.notifications)
    case .filteredByGoal(let goal):
      navigationRouter.push(.filteredByGoal(goal))
    }
  }
}

#Preview {
  HomeView()
}
