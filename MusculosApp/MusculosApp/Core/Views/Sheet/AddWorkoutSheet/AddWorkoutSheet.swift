//
//  AddWorkoutSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import SwiftUI
import Models
import Utility
import Components
import Storage

struct AddWorkoutSheet: View {
  @Environment(\.dismiss) private var dismiss

  @State private var viewModel = AddWorkoutSheetViewModel()
  
  private var muscleOptions: [String] {
    return MuscleType.allCases.map { $0.rawValue }
  }
  
  let onBack: () -> Void
  
  var body: some View {
    ScrollView {
      SheetNavBar(
        title: "Create a new workout",
        onBack: onBack,
        onDismiss: { dismiss() }
      )
      .padding(.vertical, 25)

      VStack( alignment: .leading, spacing: 15) {
        FormField(text: $viewModel.workoutName, label: "Name")
        FormField(text: $viewModel.workoutType, label: "Type")
        MultiOptionsSelectView(showOptions: $viewModel.showSelectMuscles, selectedOptions: $viewModel.selectedMuscles, title: "Target muscles", options: muscleOptions)

        if !viewModel.displayExercises.isEmpty {
          Text("Recommended Exercises")
            .font(AppFont.poppins(.medium, size: 15))
            .foregroundStyle(.black)

          ForEach(viewModel.displayExercises) { exercise in
            CardItem(
              title: exercise.name,
              isSelected: viewModel.isExerciseSelected(exercise),
              onSelect: {
                viewModel.currentSelectedExercise = exercise
              }
            )
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
      onSelectedValue: viewModel.didSelectExercise
    )
    .toastView(toast: $viewModel.toast)
    .onReceive(viewModel.didSavePublisher, perform: { _ in
      dismiss()
    })
    .onDisappear(perform: viewModel.cleanUp)
  }
}

#Preview {
  AddWorkoutSheet(onBack: {})
}
