//
//  ExerciseCardsStack.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.10.2024.
//

import SwiftUI
import Models

public struct ExerciseCardsStack: View {
  var exercises: [Exercise]
  var onTapExercise: (Exercise) -> Void

  public init(exercises: [Exercise], onTapExercise: @escaping (Exercise) -> Void) {
    self.exercises = exercises
    self.onTapExercise = onTapExercise
  }

  public var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 20) {
        ForEach(exercises, id: \.hashValue) { exercise in
          Button(action: {
            onTapExercise(exercise)
          }, label: {
            ExerciseSecondaryCard(exercise: exercise)
          })
        }
      }
    }
  }
}
