//
//  ExercisePrimaryCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.11.2024.
//

import SwiftUI
import Components
import Utility
import Models

struct ExercisePrimaryCard: View {
  let exercise: Exercise
  
  var body: some View {
    RoundedRectangle(cornerRadius: 18)
      .foregroundStyle(exercise.levelColor)
      .frame(maxWidth: .infinity)
      .frame(height: 400)
      .overlay {
        VStack {
          Heading(exercise.name, fontSize: 16)
          Text(exercise.equipment ?? "")
            .font(AppFont.poppins(.regular, size: 14))
          
        }
        .foregroundStyle(.white)
      }
    
  }
}

#Preview {
  ExercisePrimaryCard(exercise: ExerciseFactory.createExercise())
}
