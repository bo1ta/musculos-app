//
//  ExerciseSectionView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//

import Components
import Foundation
import Models
import SwiftUI

struct ExerciseSectionView: View {
  let title: String
  let exercises: [Exercise]
  let onExerciseTap: (Exercise) -> Void

  init(title: String, exercises: [Exercise], onExerciseTap: @escaping (Exercise) -> Void) {
    self.title = title
    self.exercises = exercises
    self.onExerciseTap = onExerciseTap
  }

  var body: some View {
    ContentSectionWithHeaderAndButton(
      headerTitle: title,
      buttonTitle: "See more",
      onAction: {},
      content: {
        ExerciseCardsStack(exercises: exercises, onTapExercise: onExerciseTap)
          .shadow(radius: 1.0)
      }
    )
  }
}
