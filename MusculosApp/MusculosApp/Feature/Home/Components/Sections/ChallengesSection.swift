//
//  ChallengesSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.09.2024.
//

import SwiftUI
import Utility
import Components
import Models

struct ChallengesSection: View {
  let onSeeMore: () -> Void

  init(onSeeMore: @escaping () -> Void) {
    self.onSeeMore = onSeeMore
  }

  var body: some View {
    ContentSectionWithHeaderAndButton(
      headerTitle: "Today's Challenge",
      buttonTitle: "See more",
      onAction: onSeeMore,
      content: {
        ScrollView(.horizontal) {
          HStack {
            ForEach(ChallengeType.allCases, id: \.rawValue) { challengeType in
              ChallengeCard(label: challengeType.title, level: "expert", icon: Image(challengeType.imageName), cardColor: challengeType.color)
            }
            .padding([.vertical, .horizontal], 5)
          }
        }
        .scrollIndicators(.hidden)
      })
  }
}

// MARK: - Challenge Type

extension ChallengesSection {
  private enum ChallengeType: Int, CaseIterable {
    case pushups
    case squats
    case crunches
    case stretching

    var imageName: String {
      switch self {
      case .pushups:
        return "stickman-push-ups"
      case .squats:
        return "stickman-squats"
      case .crunches:
        return "stickman-crunches"
      case .stretching:
        return "stickman-stretching"
      }
    }

    var title: String {
      switch self {
      case .pushups:
        return "Push-ups"
      case .squats:
        return "Squats"
      case .crunches:
        return "Crunches"
      case .stretching:
        return "Stretching"
      }
    }

    var color: Color {
      switch self {
      case .pushups:
        return .red
      case .squats:
        return .blue
      case .crunches:
        return .green
      case .stretching:
        return .orange
      }
    }
  }
}

#Preview {
  ChallengesSection(onSeeMore: {})
}
