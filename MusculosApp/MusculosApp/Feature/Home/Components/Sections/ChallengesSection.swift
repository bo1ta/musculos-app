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
    VStack(alignment: .leading) {
      HStack {
        Text("Today Challenge")
          .font(AppFont.spartan(.semiBold, size: 20))
        Spacer()

        Button(action: onSeeMore, label: {
          Text("See more")
            .font(AppFont.poppins(.regular, size: 15))
            .foregroundStyle(.orange)
        })
      }

      ScrollView(.horizontal) {
        HStack {
          ForEach(Goal.Category.allCases, id: \.self) { category in
            ChallengeCard(label: "New card", level: "expert", cardColor: colors.randomElement() ?? .black)
          }
          .padding(.vertical, 5)
          .padding(.horizontal, 5)
        }
      }
      .scrollIndicators(.hidden)
    }
  }
}

#Preview {
  ChallengesSection(onSeeMore: {})
}
