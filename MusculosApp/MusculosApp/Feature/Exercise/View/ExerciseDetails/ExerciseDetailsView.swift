//
//  ExerciseDetailsView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2024.
//

import SwiftUI
import Factory
import Models
import Components

struct ExerciseDetailsView: View {
  @Environment(\.navigationRouter) private var navigationRouter

  @State private var viewModel: ExerciseDetailsViewModel

  var exercise: Exercise
  var onComplete: (() -> Void)? = nil

  init(exercise: Exercise, onComplete: (() -> Void)? = nil) {
    self.viewModel = ExerciseDetailsViewModel(exercise: exercise)
    self.exercise = exercise
    self.onComplete = onComplete
  }

  var body: some View {
    VStack(spacing: 10) {
      AnimatedURLImageView(imageURLs: exercise.getImagesURLs())
        .ignoresSafeArea()
        .overlay {
          VStack {
            HStack(alignment: .top) {
              Button(action: navigationRouter.pop, label: {
                Image(systemName: "chevron.left")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(height: 20)
                  .foregroundStyle(.white)
                  .bold()
                Spacer()
              })
            }
            Spacer()
          }
          .padding()
        }

      ScrollView {
        ExerciseSummarySection(exercise: exercise, onFavorite: {})
          .padding(.horizontal)
        HStack(spacing: 15) {
          EquipmentCard(equipmentType: exercise.equipmentType)
          StarsRatingCard(stars: 4.0)
        }
        .padding(.horizontal)

        VStack {
          ForEach(Array(exercise.instructions.enumerated()), id: \.element) { index, instruction in
            DetailCardView(title: instruction, index: index + 1)
          }
        }
        .padding(.top)
      }
      .padding(.top, -60)
      .scrollIndicators(.hidden)

      Spacer()
    }
    .safeAreaInset(edge: .bottom) {
      ActionButton(title: "Start workout", systemImageName: "arrow.up.right", onClick: {
        if viewModel.isTimerActive {
          viewModel.stopTimer()
          onComplete?()
        } else {
          viewModel.startTimer()
        }
      })
      .padding(.horizontal)
    }
    .task {
      await viewModel.initialLoad()
    }
    .onDisappear(perform: viewModel.cleanUp)
    .dismissingGesture(direction: .left, action: navigationRouter.pop)
    .navigationBarBackButtonHidden()

  }
}

#Preview {
  ExerciseDetailsView(exercise: ExerciseFactory.createExercise(isFavorite: true))
}
