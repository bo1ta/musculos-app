//
//  ExerciseDetailsContent.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.12.2024.
//

import SwiftUI
import Utility
import Components
import Models

struct ExerciseDetailsContent: View {
  let viewModel: ExerciseDetailsViewModel

  var body: some View {
    ScrollView {
      ExerciseSummarySection(exercise: viewModel.exercise, onFavorite:  { viewModel.updateFavorite(!viewModel.isFavorite) })
        .padding(.horizontal)

      HStack(spacing: 15) {
        EquipmentCard(equipmentType: viewModel.exercise.equipmentType)
        StarsRatingCard(stars: viewModel.ratingAverage, onClick: { viewModel.showRatingDialog.toggle() })
      }
      .padding(.horizontal)

      VStack {
        ForEach(Array(viewModel.exercise.instructions.enumerated()), id: \.element) { index, instruction in
          ExerciseInstructionRow(title: instruction, index: index + 1)
        }
      }
      .padding(.top)
    }
    .padding(.top, -60)
    .scrollIndicators(.hidden)
  }
}

