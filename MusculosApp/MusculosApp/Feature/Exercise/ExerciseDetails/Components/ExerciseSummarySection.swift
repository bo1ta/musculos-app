//
//  ExerciseSummarySection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.10.2024.
//

import SwiftUI
import Models
import Components
import Utility

struct ExerciseSummarySection: View {
  let exercise: Exercise
  let onFavorite: () -> Void

  private var heartColor: Color {
    return exercise.isFavorite ?? false ? .red : .white
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      HStack {
        Text(exercise.name)
          .font(AppFont.poppins(.bold, size: 19))
        Spacer()
        Button(action: onFavorite, label: {
          Image("heart-icon")
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(heartColor)
            .aspectRatio(contentMode: .fit)
            .frame(height: 30)
        })
      }

      TextPillsStack(options: exercise.displayOptions)
    }
  }
}

#Preview {
  ExerciseSummarySection(exercise: ExerciseFactory.createExercise(isFavorite: true), onFavorite: {})
}
