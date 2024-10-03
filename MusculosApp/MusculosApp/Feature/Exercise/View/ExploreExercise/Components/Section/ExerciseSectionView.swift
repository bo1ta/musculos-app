//
//  ExerciseSectionView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//

import Foundation
import SwiftUI
import Models
import Components

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
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 20) {
            ForEach(exercises, id: \.hashValue) { exercise in
              Button(action: {
                onExerciseTap(exercise)
              }, label: {
                ExerciseCard(exercise: exercise)
              })
            }
          }
        }
        .shadow(radius: 1.0)
      })
  }
}
