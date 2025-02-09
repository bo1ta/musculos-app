//
//  ChallengesSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.09.2024.
//

import Components
import Models
import Navigator
import SwiftUI
import Utility

// MARK: - ChallengesSection

struct ChallengesSection: View {
  let state: LoadingViewState<WorkoutChallenge>
  let onSelectDailyWorkout: (DailyWorkout) -> Void

  var body: some View {
    switch state {
    case .loading:
      ContentSectionWithHeader.Skeleton {
        HStack {
          ForEach(0..<5, id: \.self) { _ in
            ChallengeCard(
              label: "Some label",
              level: "Some level")
              .onTapGesture { }
              .redacted(reason: .placeholder)
              .defaultShimmering()
          }
          .padding([.horizontal], 5)
        }
      }

    case .loaded(let workoutChallenge):
      ContentSectionWithHeader(
        headerTitle: workoutChallenge.title,
        content: {
          HStack {
            ForEach(workoutChallenge.dailyWorkouts, id: \.id) { dailyWorkout in
              ChallengeCard(
                label: dailyWorkout.label,
                level: workoutChallenge.level.rawValue)
                .onTapGesture {
                  onSelectDailyWorkout(dailyWorkout)
                }
            }
            .padding([.horizontal], 5)
          }
        })

    default:
      EmptyView()
    }
  }
}

// MARK: ChallengesSection.ChallengeType

extension ChallengesSection {
  private enum ChallengeType: Int, CaseIterable {
    case pushups
    case squats
    case crunches
    case stretching

    var imageName: String {
      switch self {
      case .pushups:
        "stickman-push-ups"
      case .squats:
        "stickman-squats"
      case .crunches:
        "stickman-crunches"
      case .stretching:
        "stickman-stretching"
      }
    }

    var title: String {
      switch self {
      case .pushups:
        "Push-ups"
      case .squats:
        "Squats"
      case .crunches:
        "Crunches"
      case .stretching:
        "Stretching"
      }
    }

    var color: Color {
      switch self {
      case .pushups:
        .red
      case .squats:
        .blue
      case .crunches:
        .green
      case .stretching:
        .orange
      }
    }
  }
}
