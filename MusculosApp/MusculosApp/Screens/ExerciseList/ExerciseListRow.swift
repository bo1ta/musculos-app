//
//  ExerciseListRow.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import Components
import Models
import Storage
import SwiftUI
import Utility

struct ExerciseListRow: View {
  var exercise: Exercise

  var body: some View {
    HStack {
      WorkoutIcon(category: exercise.category)

      VStack(alignment: .leading) {
        Text(exercise.name)
          .font(AppFont.poppins(.semibold, size: 13))
          .foregroundStyle(.black)

        TextPillsStack(options: exercise.displayOptions)
      }

      Spacer()

      Text(exercise.level)
        .font(AppFont.poppins(.regular, size: 10))
        .foregroundStyle(exercise.levelColor)
        .fixedSize(horizontal: true, vertical: false)
        .shadow(radius: 0.8)
    }
  }
}

#Preview {
  ExerciseListRow(exercise: ExerciseFactory.createExercise())
}
