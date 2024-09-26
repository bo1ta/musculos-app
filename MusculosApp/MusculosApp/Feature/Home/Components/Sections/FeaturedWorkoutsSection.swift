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

  let onSeeMore: () -> Void

  init(onSeeMore: @escaping () -> Void) {
    self.onSeeMore = onSeeMore
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Featured workouts")
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
  FeaturedWorkoutsSection(onSeeMore: {})
}
