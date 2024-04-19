//
//  AddWorkoutSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.04.2024.
//

import Foundation
import SwiftUI

final class AddWorkoutSheetViewModel: ObservableObject {
  @Published var exerciseName: String = ""
  @Published var workoutType: String = ""
  @Published var selectedExercises: [WorkoutExercise] = []
  @Published var muscleSearchQuery: String = ""
  @Published var debouncedMuscleSearchQuery: String = ""
  @Published var showRepsDialog: Bool = false
  
  @Published var currentSelectedExercise: Exercise? = nil {
    didSet {
      if currentSelectedExercise != nil {
        showRepsDialog = true
      } else {
        showRepsDialog = false
      }
    }
  }
  
  private(set) var submitWorkoutTask: Task<Void, Never>?
  
  private let dataStore: WorkoutDataStore
  
  init(dataStore: WorkoutDataStore = WorkoutDataStore()) {
    self.dataStore = dataStore
    self.setupQueryDebouncer()
  }
  
  private func setupQueryDebouncer() {
    $muscleSearchQuery
      .debounce(for: DispatchQueue.SchedulerTimeType.Stride.seconds(1), scheduler: DispatchQueue.main)
      .assign(to: &$debouncedMuscleSearchQuery)
  }
  
  func isExerciseSelected(_ exercise: Exercise) -> Bool {
    return selectedExercises.first(where: { $0.exercise == exercise }) != nil
  }
  
  func didSelectExercise(with numberOfReps: Int = 0) {
    guard let exercise = currentSelectedExercise else { return }
    
    defer { currentSelectedExercise = nil }
    
    if let index = selectedExercises.firstIndex(where: { $0.exercise == exercise }) {
      selectedExercises.remove(at: index)
    } else {
      selectedExercises.append(WorkoutExercise(numberOfReps: numberOfReps, exercise: exercise))
    }
  }
  
  func cleanUp() {
    submitWorkoutTask?.cancel()
    submitWorkoutTask = nil
  }
}

// MARK: - Data Store

extension AddWorkoutSheetViewModel {
  func submitWorkout() {
    guard !selectedExercises.isEmpty, !exerciseName.isEmpty, !muscleSearchQuery.isEmpty else { return }
    
    submitWorkoutTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      let workout = Workout(
        name: self.exerciseName,
        targetMuscles: [self.muscleSearchQuery],
        workoutType: self.workoutType,
        workoutExercises: self.selectedExercises
      )
      await self.dataStore.create(workout)
    }
  }
}
