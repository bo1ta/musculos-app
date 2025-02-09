//
//  ProfileScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import Components
import Models
import SwiftUI
import Utility

// MARK: - ProfileScreen

struct ProfileScreen: View {
  @Environment(\.navigator) private var navigator

  @State private var viewModel = ProfileViewModel()

  var body: some View {
    ScrollView {
      VStack(spacing: 10) {
        AchievementCard(title: "You are level: \(viewModel.userLevel)", progress: viewModel.userLevelProgress)

        ContentSectionWithHeader(headerTitle: "Highlights", withScroll: false) {
          VStack {
            ForEach(Self.highlights, id: \.hashValue) { profileHighlight in
              HighlightCard(profileHighlight: profileHighlight)
            }
          }
        }

        if !viewModel.favoriteExercises.isEmpty {
          ContentSectionWithHeader(headerTitle: "Favorite exercises") {
            ExerciseCardsStack(
              exercises: viewModel.favoriteExercises,
              onTapExercise: { navigator.navigate(to: CommonDestinations.exerciseDetails($0)) })
          }
        }
      }
      .padding(.horizontal, 15)
      .padding(.bottom, 30)
    }
    .task {
      await viewModel.initialLoad()
    }
    .scrollIndicators(.hidden)
  }
}

// MARK: - Constants

extension ProfileScreen {
  private static let highlights: [ProfileHighlight] = [
    ProfileHighlight(highlightType: .steps, value: "5432", description: "updated 10 mins ago"),
    ProfileHighlight(highlightType: .sleep, value: "7 hr 31 min", description: "updated 10 mins ago"),
    ProfileHighlight(highlightType: .waterIntake, value: "4.2 ltr", description: "updated now"),
    ProfileHighlight(highlightType: .workoutTracking, value: "1 day since last workout", description: "updated a day ago"),
  ]
}

// MARK: - Preview

#Preview {
  ProfileScreen()
}
