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
  let workoutChallenge: WorkoutChallenge
  let onSelectDailyWorkout: (DailyWorkout) -> Void

  var body: some View {
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
