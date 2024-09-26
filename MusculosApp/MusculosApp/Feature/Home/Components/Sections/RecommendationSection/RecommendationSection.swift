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
  private let gridRows = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  let exercises: [Exercise]
  let onSelectExercise: (Exercise) -> Void
  let onSeeMore: () -> Void

  init(
    exercises: [Exercise],
    onSelectExercise: @escaping (Exercise) -> Void,
    onSeeMore: @escaping () -> Void
  ) {
    self.exercises = exercises
    self.onSelectExercise = onSelectExercise
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
        LazyHGrid(rows: gridRows, spacing: 20) {
            ForEach(exercises, id: \.id) { exercise in
              Button(action: {
                onSelectExercise(exercise)
              }, label: {
                ContentTitleOptionsCard(title: exercise.name, options: exercise.primaryMuscles, content: {
                  SectionItemImage(imageURL: exercise.displayImageURL)
                })
              })
            }
          }
        .padding(.vertical, 10)
      }
      .scrollIndicators(.hidden)
    }
  }
}
