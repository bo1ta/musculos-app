//
//  YourWorkoutSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.10.2024.
//

import SwiftUI
import Models
import Components

struct YourWorkoutSection: View {
  var exercises: [Exercise]
  @Binding var selectedCategory: String?

  var body: some View {
    ContentSectionWithHeaderAndButton(headerTitle: "Your workout", buttonTitle: "See more", onAction: {}, content: {
      SelectTextResizablePillsStack(options: ExerciseConstants.categoryOptions, selectedOption: $selectedCategory)
      ExerciseCardsStack(exercises: exercises, onTapExercise: { _ in })
    })
  }
}

#Preview {
  YourWorkoutSection(exercises: [], selectedCategory: .constant(nil))
}
