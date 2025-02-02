//
//  ExerciseDetailsHeader.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.12.2024.
//

import Components
import Models
import SwiftUI

struct ExerciseDetailsHeader: View {
  let exercise: Exercise
  let onBack: () -> Void

  var body: some View {
    AnimatedURLImageView(imageURLs: exercise.getImagesURLs())
      .ignoresSafeArea()
      .overlay {
        VStack {
          HStack(alignment: .top) {
            BackButton(onPress: onBack)
            Spacer()
          }
          .padding()
          Spacer()
        }
      }
  }
}
