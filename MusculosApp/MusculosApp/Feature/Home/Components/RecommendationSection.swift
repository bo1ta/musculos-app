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

  var body: some View {
    VStack(alignment: .leading) {
      Text("Best for you")
        .font(AppFont.poppins(.medium, size: 20))

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
  RecommendationSection()
}
