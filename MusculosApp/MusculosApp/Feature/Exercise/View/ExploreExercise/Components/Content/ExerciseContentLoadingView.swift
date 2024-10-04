//
//  ExerciseContentLoadingView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.02.2024.
//

import Foundation
import SwiftUI
import Shimmer
import Models

struct ExerciseContentLoadingView: View {
  let mockExercises = [
    ExerciseFactory.createExercise(),
    ExerciseFactory.createExercise(),
    ExerciseFactory.createExercise()
  ]

  var body: some View {
    VStack {
      ExerciseSectionView(title: "Most popular", exercises: mockExercises, onExerciseTap: { _ in })
        .redacted(reason: .placeholder)
        .defaultShimmering()
      ExerciseSectionView(title: "Quick muscle-building workouts", exercises: mockExercises, onExerciseTap: { _ in })
        .redacted(reason: .placeholder)
        .defaultShimmering()
    }
  }
}

#Preview {
  ExerciseContentLoadingView()
}
