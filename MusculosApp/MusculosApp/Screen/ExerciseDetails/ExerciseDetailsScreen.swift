//
//  ExerciseDetailsScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2024.
//

import SwiftUI
import Models
import Components
import Utility
import Storage

struct ExerciseDetailsScreen: View {
  @Namespace private var animationNamespace
  private let timerActionAnimationID = "timerActionAnimationID"

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
              BackButton(onPress: navigationRouter.pop)
              Spacer()
            }
            .padding()
            Spacer()
          }
        }

      ScrollView {
        ExerciseSummarySection(exercise: exercise, onFavorite: {})
          .padding(.horizontal)
        HStack(spacing: 15) {
          EquipmentCard(equipmentType: exercise.equipmentType)
          StarsRatingCard(stars: viewModel.ratingAverage, onClick: { viewModel.showRatingDialog.toggle() })
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
      Group {
        if viewModel.isTimerActive {
          ProgressButton(elapsedTime: viewModel.elapsedTime, onStop: viewModel.stopTimer)
            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .opacity))
            .matchedGeometryEffect(id: timerActionAnimationID, in: animationNamespace)
        } else {
          ActionButton(title: "Start workout", systemImageName: "arrow.up.right", onClick: { viewModel.showInputDialog.toggle() })
            .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .top)))
            .matchedGeometryEffect(id: timerActionAnimationID, in: animationNamespace)
        }
      }
      .animation(.easeInOut(duration: UIConstant.shortAnimationDuration), value: viewModel.isTimerActive)
      .padding(.horizontal)
    }
    .task {
      await viewModel.initialLoad()
    }
    .onDisappear(perform: viewModel.cleanUp)
    .dismissingGesture(direction: .left, action: navigationRouter.pop)
    .navigationBarBackButtonHidden()
    .animatedScreenBorder(isActive: viewModel.isTimerActive)
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
  }
}

#Preview {
  ExerciseDetailsScreen(exercise: ExerciseFactory.createExercise(isFavorite: true))
}
