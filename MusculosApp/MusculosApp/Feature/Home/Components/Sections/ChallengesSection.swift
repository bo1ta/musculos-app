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
  let colors: [Color] = [.yellow, .red, .green, .gray]

  let onSeeMore: () -> Void

  init(onSeeMore: @escaping () -> Void) {
    self.onSeeMore = onSeeMore
  }

  var body: some View {
    ContentSectionWithHeaderAndButton(
      headerTitle: "Today Challenge",
      buttonTitle: "See more",
      onAction: onSeeMore,
      content: {
        ScrollView(.horizontal) {
          HStack {
            ForEach(Goal.Category.allCases, id: \.self) { category in
              ChallengeCard(label: "New card", level: "expert", cardColor: colors.randomElement() ?? .black)
            }
            .padding([.vertical, .horizontal], 5)
          }
        }
        .scrollIndicators(.hidden)
      })
  }
}

#Preview {
  ChallengesSection(onSeeMore: {})
}
