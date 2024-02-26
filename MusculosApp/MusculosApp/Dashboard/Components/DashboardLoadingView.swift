//
//  DashboardLoadingView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.02.2024.
//

import Foundation
import SwiftUI

struct DashboardLoadingView: View {
  private var mockExercises: [Exercise] {
    let exercise = MockConstants.createMockExercise()
    let exercise2 = MockConstants.createMockExercise()
    return [exercise, exercise2]
  }
  
  var body: some View {
    VStack {
      ExerciseCardSection(title: "Most popular", exercises: mockExercises, onExerciseTap: { _ in })
      ExerciseCardSection(title: "Quick muscle-building workouts", exercises: mockExercises, isSmallCard: true, onExerciseTap: { _ in })
    }
    .shimmering()
  }
}

#Preview {
  DashboardLoadingView()
}
