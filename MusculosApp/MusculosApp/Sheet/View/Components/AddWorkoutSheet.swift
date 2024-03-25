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
  
  @State private var selectedExercises: [Exercise] = []
  @State private var showExercise: Exercise?
  @State private var exerciseName: String = ""
  @StateObject private var categoryObserver = DebouncedQueryObserver()
  
  let onBack: () -> Void
  
  var body: some View {
    ScrollView {
      topBar
      
      RoundedTextField(text: $exerciseName, label: "Name", textHint: "Workout Name")
        .padding(.top, 25)
      
      RoundedTextField(text: $categoryObserver.searchQuery, label: "Type", textHint: "Muscle Type")
        .padding(.top, 15)
      
      cardSection
        .padding(.top, 20)
    }
    .scrollIndicators(.hidden)
    .padding([.leading, .trailing, .top], 15)
    .onChange(of: categoryObserver.debouncedQuery) { categoryQuery in
      exerciseStore.searchByMuscleQuery(categoryQuery)
    }
    .safeAreaInset(edge: .bottom) {
      Button(action: {}, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButton())
      .padding([.leading, .trailing], 10)
    }
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
        CardItemShimmering()
        CardItemShimmering()
        CardItemShimmering()
        CardItemShimmering()
        CardItemShimmering()
        CardItemShimmering()
      case .loaded(let exercises):
        ForEach(combineWithSelected(exercises), id: \.hashValue) { exercise in
          makeCardItem(exercise: exercise)
        }
      case .empty(_), .error(_):
        EmptyView()
      }
    }
  }
}

// MARK: - Functions

extension AddWorkoutSheet {
  private func makeCardItem(exercise: Exercise) -> some View {
    CardItem(title: exercise.name,
             isSelected: selectedExercises.contains(exercise),
             onSelect: { didSelectExercise(exercise) })
  }
  
  
  private func didSelectExercise(_ exercise: Exercise) {
    if let index = selectedExercises.firstIndex(of: exercise) {
      selectedExercises.remove(at: index)
    } else {
      selectedExercises.append(exercise)
    }
  }
  
  private func combineWithSelected(_ loadedExercises: [Exercise]) -> [Exercise] {
    var exercises = selectedExercises
    let noDuplicates = loadedExercises.compactMap { exercises.contains($0) ? nil : $0 }
    exercises.append(contentsOf: noDuplicates)
    return exercises
  }
}

#Preview {
  AddWorkoutSheet(onBack: {})
    .environmentObject(ExerciseStore())
}
