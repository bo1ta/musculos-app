//
//  ExerciseCardsSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI

struct ExerciseCardsSection: View {
  let title: String
  let exercises: [ExerciseProvider]
  let onTappedExercise: (ExerciseProvider) -> Void

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.body(.bold, size: 15))
      ForEach(exercises, id: \.name) { exercise in
        Button(action: {
          onTappedExercise(exercise)
        }, label: {
          CardItem(title: exercise.name)
        })
      }
    }
  }
}

#Preview {
  ExerciseCardsSection(title: "Recommended exercises",
                       exercises: [MockConstants.createMockExercise()],
                       onTappedExercise: { _ in })
}
