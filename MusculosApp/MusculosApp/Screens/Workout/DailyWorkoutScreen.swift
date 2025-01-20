//
//  DailyWorkoutScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.01.2025.
//

import SwiftUI
import Utility
import Components
import Models
import Storage

struct DailyWorkoutScreen: View {
  @Environment(\.navigator) private var navigator

  let workoutChallenge: WorkoutChallenge
  let dailyWorkout: DailyWorkout

  var body: some View {
    VStack(spacing: 10) {
      Heading(workoutChallenge.title, fontSize: 24)
      Heading(dailyWorkout.label, fontSize: 17)

      ForEach(dailyWorkout.workoutExercises, id: \.id) { workoutExercise in
        SmallCardWithContent(
          title: workoutExercise.name,
          description: workoutExercise.label,
          gradient: AppColor.orangeGradient,
          rightContent: {
            IconButton(systemImageName: "chevron.right", action: {
              navigator.navigate(to: WorkoutDestinations.exerciseDetails(workoutExercise.exercise))
              })
          })
      }
    }
    .padding(20)
  }
}
