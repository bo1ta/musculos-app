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
  let onSeeMore: () -> Void
  let onWorkoutGoalSelected: (WorkoutGoal) -> Void

  init(onSeeMore: @escaping () -> Void, onWorkoutGoalSelected: @escaping (WorkoutGoal) -> Void) {
    self.onSeeMore = onSeeMore
    self.onWorkoutGoalSelected = onWorkoutGoalSelected
  }

  var body: some View {
    ContentSectionWithHeaderAndButton(
      headerTitle: "Featured workouts",
      buttonTitle: "See more",
      onAction: onSeeMore,
      content: {
        ScrollView(.horizontal) {
          LazyHStack {
            ForEach(WorkoutGoal.allCases, id: \.rawValue) { workoutGoal in
              Button(action: {
                onWorkoutGoalSelected(workoutGoal)
              }, label: {
                IconTitleCard(
                  icon: Image(workoutGoal.iconName),
                  imageColor: workoutGoal.color,
                  title: workoutGoal.title
                )
              })
              .buttonStyle(.plain)
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 5)
          }
        }
        .scrollIndicators(.hidden)
      })
  }
}

#Preview {
  FeaturedWorkoutsSection(onSeeMore: {}, onWorkoutGoalSelected: { _ in })
}
