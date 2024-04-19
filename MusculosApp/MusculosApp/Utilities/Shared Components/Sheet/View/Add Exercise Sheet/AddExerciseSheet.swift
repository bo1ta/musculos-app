//
//  AddExerciseSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import SwiftUI

struct AddExerciseSheet: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var exerciseStore: ExerciseStore
  
  @StateObject private var viewModel = AddExerciseSheetViewModel()
  
  let onBack: () -> Void
  
  var body: some View {
    ScrollView {
      SheetNavBar(title: "Create a new exercise",
                  onBack: onBack,
                  onDismiss: {
        dismiss()
      })
      
      RoundedTextField(
        text: $viewModel.exerciseName,
        label: "Name",
        textHint: "Exercise Name"
      )
      .padding(.top, 25)
      
      MultiOptionsSelectView(
        showOptions: $viewModel.showMusclesOptions,
        selectedOptions: $viewModel.targetMuscles,
        title: "Muscles",
        options: ExerciseConstants.muscleOptions
      )
      .padding(.top, 25)
      
      SingleOptionSelectView(
        showOptions: $viewModel.showEquipmentOptions,
        selectedOption: $viewModel.equipment,
        title: "Category",
        options: ExerciseConstants.equipmentOptions
      )
      .padding(.top, 25)
      
      SingleOptionSelectView(
        showOptions: $viewModel.showForceOptions,
        selectedOption: $viewModel.force,
        title: "Force",
        options: ExerciseConstants.forceOptions
      )
      .padding(.top, 25)
      
      SingleOptionSelectView(
        showOptions: $viewModel.showLevelOptions,
        selectedOption: $viewModel.level,
        title: "Level",
        options: ExerciseConstants.levelOptions
      )
      .padding(.top, 25)
      
      SingleOptionSelectView(
        showOptions: $viewModel.showCategoryOptions,
        selectedOption: $viewModel.category,
        title: "Category",
        options: ExerciseConstants.categoryOptions
      )
      .padding(.top, 25)
      
      WhiteBackgroundCard()
    }
    .scrollIndicators(.hidden)
    .padding([.leading, .trailing, .top], 15)
    .safeAreaInset(edge: .bottom) {
      Button(action: saveAndDismiss, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButtonStyle())
      .padding([.leading, .trailing], 10)
    }
  }
}


// MARK: - Private helpers

extension AddExerciseSheet {
  func saveAndDismiss() {
    guard let exercise = viewModel.createExercise() else { return }
    exerciseStore.addExercise(exercise)
    dismiss()
  }
}
