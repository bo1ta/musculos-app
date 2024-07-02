//
//  AddWorkoutSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import SwiftUI

struct AddWorkoutSheet: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.appManager) private var appManager
  
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
      .padding(.bottom, 25)
      
      VStack(spacing: 35) {
        
        CustomTextField(text: $viewModel.workoutName, label: "Name")
        CustomTextField(text: $viewModel.workoutType, label: "Type")
        
        CustomTextField(text: $viewModel.muscleSearchQuery, label: "Target")
        
        MultiOptionsSelectView(showOptions: $viewModel.showSelectMuscles, selectedOptions: $viewModel.selectedMuscles, title: "Target muscles", options: muscleOptions)
      }
      .padding(.horizontal, 5)
      
      VStack(alignment: .leading) {
        Text("Recommended exercises")
          .font(.body(.bold, size: 14))
        switch viewModel.state {
        case .loading:
          ForEach(0..<5, id: \.self) { _ in
            CardItemShimmering()
              .onAppear(perform: viewModel.initialLoad)
          }
        case .loaded(let exercises):
          ForEach(combineWithSelected(exercises), id: \.hashValue) { exercise in
            CardItem(
              title: exercise.name,
              isSelected: viewModel.isExerciseSelected(exercise),
              onSelect: {
                viewModel.currentSelectedExercise = exercise
              }
            )
          }
        case .empty, .error(_):
          HStack {
            Spacer()
            HintIconView(systemImage: "water.waves", textHint: "")
            Spacer()
          }
          .onAppear(perform: viewModel.initialLoad)
          .padding(.top, 20)
        }
      }
      .transition(.blurReplace)
      .padding(.horizontal, 5)
      .padding(.top, 20)
    }
    .scrollIndicators(.hidden)
    .padding([.horizontal, .top], 15)
    .safeAreaInset(edge: .bottom) {
      Button(action: viewModel.submitWorkout, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButtonStyle())
      .padding(.horizontal, 10)
    }
    .dialog(
      style: .select,
      title: "How many reps?",
      buttonTitle: "Save",
      isPresented: $viewModel.showRepsDialog,
      onSelectedValue: viewModel.didSelectExercise
    )
    .onReceive(viewModel.didSaveSubject, perform: { isSuccessful in
      if isSuccessful {
        appManager.showToast(style: .info, message: "Goal saved! Good luck!")
        appManager.notifyModelUpdate(.didAddGoal)
        dismiss()
      } else {
        appManager.showToast(style: .error, message: "Could not save goal. Please try again")
      }
    })
    .animation(.easeInOut(duration: 0.2), value: viewModel.state)
    .onDisappear(perform: viewModel.cleanUp)
  }
}

// MARK: - Private Functions

extension AddWorkoutSheet {
  private func combineWithSelected(_ loadedExercises: [Exercise]) -> [Exercise] {
    var exercises = viewModel.selectedExercises.compactMap { $0.exercise }
    let noDuplicates = loadedExercises.compactMap { exercises.contains($0) ? nil : $0 }
    exercises.append(contentsOf: noDuplicates)
    return exercises
  }
}

#Preview {
  AddWorkoutSheet(onBack: {})
}
