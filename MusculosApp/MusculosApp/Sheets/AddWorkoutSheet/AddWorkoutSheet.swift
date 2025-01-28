//
//  AddWorkoutSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import Components
import Models
import Storage
import SwiftUI
import Utility

struct AddWorkoutSheet: View {
  @Environment(\.dismiss) private var dismiss

  @State private var viewModel = AddWorkoutSheetViewModel()

  private var muscleOptions: [String] {
    MuscleType.allCases.map { $0.rawValue }
  }

  let onBack: () -> Void

  var body: some View {
    ScrollView {
      SheetNavBar(
        title: "Create a new workout",
        onBack: onBack,
        onDismiss: { dismiss() })
        .padding(.vertical, 25)

      VStack(alignment: .leading, spacing: 15) {
        FormField(text: $viewModel.workoutName, label: "Name")

        SingleOptionSelectView(
          showOptions: $viewModel.showSelectMuscles,
          selectedOption: $viewModel.workoutType,
          title: "Workout Type",
          options: ExerciseConstants.categoryOptions)
        MultiOptionsSelectView(
          showOptions: $viewModel.showSelectMuscles,
          selectedOptions: $viewModel.selectedMuscles,
          title: "Target muscles",
          options: muscleOptions)

        if !viewModel.displayExercises.isEmpty {
          Text("Recommended Exercises")
            .font(AppFont.poppins(.medium, size: 15))
            .foregroundStyle(.black)

          ForEach(viewModel.displayExercises) { exercise in
            SelectTitleCard(
              title: exercise.name,
              isSelected: viewModel.isExerciseSelected(exercise),
              onSelect: { viewModel.willSelectExercise(exercise) })
          }
        }
      }
      .padding(.horizontal, 5)
    }
    .scrollIndicators(.hidden)
    .padding([.horizontal, .top], 15)
    .safeAreaInset(edge: .bottom) {
      Button(action: viewModel.submitWorkout, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(ActionButtonStyle())
      .padding(.horizontal, 10)
    }
    .sliderDialog(
      title: "How many reps?",
      buttonTitle: "Save",
      isPresented: $viewModel.showRepsDialog,
      onSelectedValue: viewModel.didSelectExercise)
    .onReceive(viewModel.didSavePublisher, perform: { _ in
      dismiss()
    })
  }
}
