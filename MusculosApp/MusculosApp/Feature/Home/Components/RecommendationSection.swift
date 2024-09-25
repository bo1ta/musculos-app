//
//  RecommendationSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import SwiftUI
import Components
import Utility
import Models

struct RecommendationSection: View {
  let rows = [
      GridItem(.flexible()),  // Defines the first column
      GridItem(.flexible())   // Defines the second column
  ]

  let onSeeMore: () -> Void
  init(onSeeMore: @escaping () -> Void) {
    self.onSeeMore = onSeeMore
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Best for you")
          .font(AppFont.spartan(.semiBold, size: 20))
        Spacer()

        Button(action: onSeeMore, label: {
          Text("See more")
            .font(AppFont.spartan(.regular, size: 17))
            .foregroundStyle(.orange)
        })
      }

      ScrollView(.horizontal) {
        LazyHGrid(rows: rows, spacing: 20) {
            ForEach(Goal.Category.allCases, id: \.self) { category in
              ImageTitleOptionsCard(
                image: Image("muscle-icon"),
                title: category.label,
                options: ["10 min", "beginner"]
              )
            }
          }
        .padding(.vertical, 10)
      }
      .scrollIndicators(.hidden)
    }
  }
}

#Preview {
  RecommendationSection(onSeeMore: {})
}
