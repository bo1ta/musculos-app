//
//  RecommendationSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import Components
import Models
import SwiftUI
import Utility

struct RecommendationSection: View {
  private let gridRows = [
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]

  let goal: Goal
  let exercises: [Exercise]
  let onSelectExercise: (Exercise) -> Void
  let onSeeMore: () -> Void

  init(
    goal: Goal,
    exercises: [Exercise],
    onSelectExercise: @escaping (Exercise) -> Void,
    onSeeMore: @escaping () -> Void)
  {
    self.goal = goal
    self.exercises = exercises
    self.onSelectExercise = onSelectExercise
    self.onSeeMore = onSeeMore
  }

  var body: some View {
    ContentSectionWithHeader(
      headerTitle: "Recommendations for your \(goal.name) goal",
      content: {
        ScrollView(.horizontal) {
          LazyHGrid(rows: gridRows, spacing: 20) {
            ForEach(exercises, id: \.id) { exercise in
              Button(action: {
                onSelectExercise(exercise)
              }, label: {
                ContentTitleOptionsCard(
                  title: exercise.displayName,
                  options: exercise.primaryMuscles,
                  content: {
                    SectionItemImage(imageURL: exercise.displayImageURL)
                  })
              })
              .buttonStyle(.plain)
            }
          }
        }
        .shadow(radius: 1.2)
        .ignoresSafeArea()
        .scrollIndicators(.hidden)
      })
  }
}
