//
//  AddWorkoutSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import SwiftUI

struct AddWorkoutSheet: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var exerciseStore: ExerciseStore
  
  @StateObject var viewModel = AddWorkoutSheetViewModel()
  
  let onBack: () -> Void
  
  var body: some View {
    ScrollView {
      topBar
      
      RoundedTextField(text: $viewModel.exerciseName, label: "Name", textHint: "Workout Name")
        .padding(.top, 25)
      
      RoundedTextField(text: $viewModel.searchQuery, label: "Type", textHint: "Muscle Type")
        .padding(.top, 15)
      
      cardSection
        .padding(.top, 20)
    }
    .scrollIndicators(.hidden)
    .padding([.leading, .trailing, .top], 15)
    .onChange(of: viewModel.debouncedQuery) { categoryQuery in
      exerciseStore.searchByMuscleQuery(categoryQuery)
    }
    .safeAreaInset(edge: .bottom) {
      Button(action: viewModel.submitWorkout, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButton())
      .padding([.leading, .trailing], 10)
    }
    .sheet(isPresented: $viewModel.showRepsDialog, content: {
      DialogSelectView(title: "How many reps?", onButtonTap: { numberOfReps in
        if let currentSelectedExercise = viewModel.currentSelectedExercise {
          viewModel.didSelectExercise(currentSelectedExercise, numberOfReps: numberOfReps)
          viewModel.currentSelectedExercise = nil
        }
      })
    })
    .onAppear(perform: viewModel.getAll)
    .onDisappear(perform: viewModel.cleanUp)
  }
}

// MARK: - Views

extension AddWorkoutSheet {
  private var topBar: some View {
    HStack {
      Button(action: onBack, label: {
        Image(systemName: "chevron.left")
          .font(.system(size: 18))
          .foregroundStyle(.gray)
      })
      
      Spacer()
      
      Text("Create a new workout")
        .font(.header(.bold, size: 20))
        .foregroundStyle(.black)
      
      Spacer()
      
      Button(action: {
        dismiss()
      }, label: {
        Image(systemName: "xmark")
          .font(.system(size: 18))
          .foregroundStyle(.gray)
      })
    }
  }
  
  private var cardSection: some View {
    VStack(alignment: .leading) {
      Text("Recommended exercises")
        .font(.body(.bold, size: 15))
      
      switch exerciseStore.state {
      case .loading:
        ForEach(0..<5, id: \.self) { _ in
          CardItemShimmering()
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
        EmptyView()
      }
    }
  }
}

// MARK: - Functions

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
    .environmentObject(ExerciseStore())
}
