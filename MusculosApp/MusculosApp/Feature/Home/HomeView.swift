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
          navigationRouter.push(.search)
        },
        onNotificationsTap: {
          navigationRouter.push(.notifications)
        }
      )

      AchievementCard()

      Spacer()
    }
    .padding(.horizontal, 10)
    .task {
      await viewModel.fetchData()
    }
  }
}

#Preview {
  HomeView()
}
