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
      
      RoundedTextField(
        text: $viewModel.equipment,
        label: "Equipment",
        textHint: "Equipment"
      )
      .padding(.top, 25)
      
      SingleOptionSelectView(
        showOptions: $viewModel.showForceOptions,
        selectedOption: $viewModel.force,
        title: "Force",
        options: ExerciseConstant.forceOptions
      )
      .padding(.top, 25)
      
      SingleOptionSelectView(
        showOptions: $viewModel.showLevelOptions,
        selectedOption: $viewModel.level,
        title: "Level",
        options: ExerciseConstant.levelOptions
      )
      .padding(.top, 25)
      
      MultiOptionsSelectView(
        showOptions: $viewModel.showMusclesOptions,
        selectedOptions: $viewModel.targetMuscles,
        title: "Target Muscles",
        options: ExerciseConstant.muscleOptions
      )
      .padding(.top, 25)
      
      WhiteBackgroundCard()
    }
    .scrollIndicators(.hidden)
    .padding([.leading, .trailing, .top], 15)
    .safeAreaInset(edge: .bottom) {
      Button(action: { }, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButton())
      .padding([.leading, .trailing], 10)
    }
    .onDisappear(perform: exerciseStore.cleanUp)
  }
}
