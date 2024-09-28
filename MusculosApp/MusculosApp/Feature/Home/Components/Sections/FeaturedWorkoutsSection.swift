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
  FeaturedWorkoutsSection(onSeeMore: {}, onWorkoutGoalSelected: { _ in })
}
