//
//  ExerciseDetailsScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2024.
//

import Components
import Models
import Storage
import SwiftUI
import Utility

struct ExerciseDetailsScreen: View {
  @Environment(\.navigator) private var navigator
  @State private var viewModel: ExerciseDetailsViewModel

  var exercise: Exercise

  init(exercise: Exercise) {
    viewModel = ExerciseDetailsViewModel(exercise: exercise)
    self.exercise = exercise
  }

  var body: some View {
    VStack(spacing: 10) {
      ExerciseDetailsHeader(exercise: exercise, onBack: { navigator.pop() })
      ExerciseDetailsContent(viewModel: viewModel)
    }
    .task {
      await viewModel.initialLoad()
    }
    .onDisappear(perform: viewModel.cleanUp)
    .frame(alignment: .top)
    .safeAreaInset(edge: .bottom) {
      ExerciseDetailsButton(elapsedTime: viewModel.elapsedTime, isTimerActive: viewModel.isTimerActive, onClick: viewModel.handleSubmit)
    }
    .sheet(isPresented: $viewModel.showInputDialog, content: {
      SelectWeightSheet(weight: $viewModel.inputWeight, onSubmit: viewModel.startTimer)
        .presentationDetents([.height(300)])
    })
    .ratingDialog(
      isPresented: $viewModel.showRatingDialog,
      title: "Rate exercise",
      rating: $viewModel.userRating,
      onSave: viewModel.saveRating(_:)
    )
    .modifier(XPGainViewModifier(showView: viewModel.showXPGainDialog, xpGained: viewModel.currentXPGain))
    .animatedScreenBorder(isActive: viewModel.isTimerActive)
    .dismissingGesture(direction: .left, action: { navigator.pop() })
    .navigationBarBackButtonHidden()
    .tabBarHidden()
  }
}

#Preview {
  ExerciseDetailsScreen(
    exercise: ExerciseFactory.createExercise(isFavorite: true)
  )
}
