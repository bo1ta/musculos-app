//
//  AddWorkoutSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.04.2024.
//

import Foundation
import SwiftUI

final class AddWorkoutSheetViewModel: ObservableObject {
  @Published var showExerciseDetail: Exercise? = nil
  @Published var exerciseName: String = ""
  @Published var selectedExercises: [Exercise] = []
  @Published var searchQuery: String = ""
  @Published var debouncedQuery: String = ""
  
  @Published var workouts: [Workout] = []
  
  private(set) var submitWorkoutTask: Task<Void, Never>?
  private(set) var getAllTask: Task<Void, Never>?
  
  private let dataStore: WorkoutDataStore
  
  init(dataStore: WorkoutDataStore = WorkoutDataStore()) {
    self.dataStore = dataStore
    self.setupQueryDebouncer()
  }
  
  private func setupQueryDebouncer() {
    $searchQuery
      .debounce(for: DispatchQueue.SchedulerTimeType.Stride.seconds(1), scheduler: DispatchQueue.main)
      .assign(to: &$debouncedQuery)
  }
  
  func didSelectExercise(_ exercise: Exercise) {
    if let index = selectedExercises.firstIndex(of: exercise) {
      selectedExercises.remove(at: index)
    } else {
      selectedExercises.append(exercise)
    }
  }
  
  func cleanUp() {
    submitWorkoutTask?.cancel()
    submitWorkoutTask = nil
    
    getAllTask?.cancel()
    getAllTask = nil
  }
}

// MARK: - Data Store

extension AddWorkoutSheetViewModel {
  func getAll() {
    getAllTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.workouts = await self.dataStore.getAll()
    }
  }
  
  func submitWorkout() {
    guard !selectedExercises.isEmpty, !exerciseName.isEmpty, !searchQuery.isEmpty else { return }
    
    submitWorkoutTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      let workout = Workout(
        name: self.exerciseName,
        targetMuscles: [self.searchQuery],
        workoutType: "mixed",
        exercises: self.selectedExercises
      )
      await self.dataStore.create(workout)
    }
  }
}
