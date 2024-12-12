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
      .padding(.bottom, 25)
      
      VStack(spacing: 35) {
        FormField(text: $viewModel.workoutName, label: "Name")
        FormField(text: $viewModel.workoutType, label: "Type")
        FormField(text: $viewModel.muscleSearchQuery, label: "Target")

        MultiOptionsSelectView(showOptions: $viewModel.showSelectMuscles, selectedOptions: $viewModel.selectedMuscles, title: "Target muscles", options: muscleOptions)
      }
      .padding(.horizontal, 5)

      VStack(alignment: .leading) {
        Text("Recommended exercises")
          .font(.body(.bold, size: 14))

        switch viewModel.state {
        case .loading:
          CardItemShimmering()
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
        case .empty:
          EmptyView()
        case .error(let errorMessage):
          Text(errorMessage)
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
    .sliderDialog(
      title: "How many reps?",
      buttonTitle: "Save",
      isPresented: $viewModel.showRepsDialog,
      onSelectedValue: viewModel.didSelectExercise
    )
    .animation(.easeInOut(duration: 0.2), value: viewModel.state)
    .onReceive(viewModel.didSaveSubject, perform: { _ in
      dismiss()
    })
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
