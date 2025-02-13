//
//  ExerciseSecondaryCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import Components
import Models
import NetworkClient
import Shimmer
import Storage
import SwiftUI
import Utility

struct ExerciseSecondaryCard: View {
  let exercise: Exercise

  init(exercise: Exercise) {
    self.exercise = exercise
  }

  var body: some View {
    RoundedRectangle(cornerRadius: 20)
      .frame(width: 250, height: 260)
      .shadow(radius: 1.0)
      .foregroundStyle(.white)
      .overlay {
        VStack(alignment: .leading) {
          backgroundView

          Spacer()

          Group {
            Text(exercise.name)
              .font(AppFont.poppins(.semibold, size: 15))
              .foregroundStyle(.black)
            TextResizablePillsStack(options: Array(exercise.displayOptions.prefix(2)))
          }
          .padding(.horizontal)

          Spacer()
        }
      }
  }

  // MARK: Skeleton

  struct Skeleton: View {
    var body: some View {
      RoundedRectangle(cornerRadius: 20)
        .frame(width: 250, height: 260)
        .shadow(radius: 1.0)
        .foregroundStyle(.white)
        .overlay {
          VStack(alignment: .leading) {
            Color.gray
              .frame(width: 250, height: 140)
              .redacted(reason: .placeholder)
              .defaultShimmering()

            Spacer()

            Group {
              Text("Exercise name")
                .font(AppFont.poppins(.semibold, size: 15))
                .foregroundStyle(.black)
                .redacted(reason: .placeholder)
              TextResizablePillsStack(options: ["First option", "Second option"])
                .redacted(reason: .placeholder)
            }
            .padding(.horizontal)

            Spacer()
          }
        }
    }
  }

  // MARK: - Views

  @ViewBuilder
  private var backgroundView: some View {
    if let imageUrl = exercise.displayImageURL {
      AsyncCachedImage(url: imageUrl, content: { imagePhase in
        switch imagePhase {
        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 250, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 20))

        default:
          Color.gray
            .frame(width: 250, height: 140)
            .redacted(reason: .placeholder)
            .shimmering(bandSize: 0.4)
        }
      })
    }
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  ExerciseSecondaryCard(exercise: ExerciseFactory.createExercise())
}
