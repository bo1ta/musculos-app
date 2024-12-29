//
//  ProfileScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import Components
import Models
import SwiftUI

struct ProfileScreen: View {
  @Environment(\.userStore) private var userStore
  @Environment(\.navigator) private var navigator

  @State private var viewModel = ProfileViewModel()

  var body: some View {
    ScrollView {
      VStack(spacing: 10) {
        UserHeader(profile: userStore.currentUserProfile, onNotificationsTap: {})
        ContentSectionWithHeaderAndButton(headerTitle: "Overview", buttonTitle: "See more", onAction: {}, content: {
          ScoreCard(
            title: "Fitness Score",
            description: "Based on your overview fitness tracking, your score is 87 and considered good",
            score: 87,
            onTap: {}
          )
        })
        ContentSectionWithHeaderAndButton(headerTitle: "Highlights", buttonTitle: "See more", onAction: {}, content: {
          VStack {
            ForEach(viewModel.getHighlights(), id: \.hashValue) { profileHighlight in
              HighlightCard(profileHighlight: profileHighlight)
            }
          }
        })

        ContentSectionWithHeaderAndButton(headerTitle: "Your workout", buttonTitle: "See more", onAction: {}, content: {
          SelectTextResizablePillsStack(
            options: ExerciseConstants.categoryOptions,
            selectedOption: $viewModel.selectedWorkout
          )
          ExerciseCardsStack(
            exercises: viewModel.exercises,
            onTapExercise: { navigator.navigate(to: CommonDestinations.exerciseDetails($0)) }
          )
        })
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

#Preview {
  ProfileScreen()
}
