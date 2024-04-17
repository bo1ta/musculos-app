//
//  ExerciseContentLoadingView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.02.2024.
//

import Foundation
import SwiftUI

struct ExerciseContentLoadingView: View {
  let mockExercises = [ExerciseFactory.createExercise(), ExerciseFactory.createExercise(), ExerciseFactory.createExercise()]
  
  var body: some View {
    VStack {
      ExerciseSectionView(title: "Most popular", exercises: mockExercises, onExerciseTap: { _ in })
      ExerciseSectionView(title: "Quick muscle-building workouts", exercises: mockExercises, isSmallCard: true, onExerciseTap: { _ in })
    }
    .shimmering()
  }
}

#Preview {
  ExerciseContentLoadingView()
}
