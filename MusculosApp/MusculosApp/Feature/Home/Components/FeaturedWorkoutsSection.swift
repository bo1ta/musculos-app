//
//  FeaturedWorkoutsSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import SwiftUI
import Components
import Models
import Utility

struct FeaturedWorkoutsSection: View {
  let colors: [Color] = [.red, .blue, .green, .yellow]

  var body: some View {
    VStack(alignment: .leading) {
      Text("Featured Workouts")
        .font(AppFont.poppins(.medium, size: 20))

      ScrollView(.horizontal) {
        HStack {
          ForEach(Goal.Category.allCases, id: \.self) { category in
            IconTitleCard(icon: Image("muscle-icon"), imageColor: colors.randomElement() ?? .black, title: category.label)
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
  FeaturedWorkoutsSection()
}
