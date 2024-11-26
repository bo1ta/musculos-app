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
  let onWorkoutGoalSelected: (WorkoutGoal) -> Void

  init(onWorkoutGoalSelected: @escaping (WorkoutGoal) -> Void) {
    self.onWorkoutGoalSelected = onWorkoutGoalSelected
  }

  var body: some View {
    ContentSectionWithHeader(
      headerTitle: "Featured workouts",
      scrollDirection: .horizontal,
      content: {
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
          .padding([.vertical, .horizontal], 5)
        }
      }
    )
  }
}
