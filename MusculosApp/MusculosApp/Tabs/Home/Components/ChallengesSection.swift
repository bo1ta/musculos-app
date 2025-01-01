//
//  ChallengesSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.09.2024.
//

import Components
import Models
import SwiftUI
import Utility

// MARK: - ChallengesSection

struct ChallengesSection: View {
  var body: some View {
    ContentSectionWithHeader(
      headerTitle: "Today's Challenge",
      content: {
        HStack {
          ForEach(ChallengeType.allCases, id: \.rawValue) { challengeType in
            ChallengeCard(
              label: challengeType.title,
              level: "expert",
              icon: Image(challengeType.imageName),
              cardColor: challengeType.color)
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

#Preview {
  ChallengesSection()
}
