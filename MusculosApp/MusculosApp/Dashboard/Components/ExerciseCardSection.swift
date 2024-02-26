//
//  ExerciseCardSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//

import Foundation
import SwiftUI

struct ExerciseCardSection: View {
  let title: String
  let exercises: [Exercise]
  let isSmallCard: Bool
  let onExerciseTap: (Exercise) -> Void
  
  init(title: String,
       exercises: [Exercise],
       isSmallCard: Bool = false,
       onExerciseTap: @escaping (Exercise) -> Void
  ) {
    self.title = title
    self.exercises = exercises
    self.isSmallCard = isSmallCard
    self.onExerciseTap = onExerciseTap
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.custom(AppFont.bold, size: 18))
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 20) {
          ForEach(exercises, id: \.hashValue) { exercise in
            Button(action: {
              onExerciseTap(exercise)
            }, label: {
              CurrentWorkoutCardView(title: exercise.name, description: exercise.equipment, imageURL: exercise.getImagesURLs().first, options: exercise.secondaryMuscles, cardWidth: isSmallCard ? 200 : 300)
            })
          }
        }
      }
    }
    .padding()
  }
}
