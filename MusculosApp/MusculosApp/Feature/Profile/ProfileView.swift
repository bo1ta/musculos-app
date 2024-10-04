//
//  ProfileView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import SwiftUI
import Models
import Utility
import Components

struct ProfileView: View {
  @Environment(\.userStore) private var userStore
  @Environment(\.healthKitViewModel) private var healthKitViewModel

  private let highlights: [ProfileHighlight] = [
    ProfileHighlight(highlightType: .steps, value: "5432", description: "updated 10 mins ago"),
    ProfileHighlight(highlightType: .sleep, value: "7 hr 31 min", description: "updated 10 mins ago"),
    ProfileHighlight(highlightType: .waterIntake, value: "4.2 ltr", description: "updated now"),
    ProfileHighlight(highlightType: .workoutTracking, value: "1 day since last workout", description: "updated a day ago")
  ]

  var body: some View {
    ScrollView {
      VStack(spacing: 10) {
        GreetingHeader(profile: userStore.currentUserProfile, onSearchTap: {}, onNotificationsTap: {})
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
            ForEach(highlights, id: \.hashValue) { profileHighlight in
              HighlightCard(profileHighlight: profileHighlight)
            }
          }
        })

        WhiteBackgroundCard()
      }
      .padding(.horizontal, 15)
    }
    .task {
      if healthKitViewModel.isAuthorized {
        await healthKitViewModel.loadAllData()
      } else {
        // load different data
      }
    }
    .scrollIndicators(.hidden)
  }
}

#Preview {
  ProfileView()
}
