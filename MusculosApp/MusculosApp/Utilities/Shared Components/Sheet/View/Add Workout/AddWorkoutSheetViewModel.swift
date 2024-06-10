//
//  AddWorkoutSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.04.2024.
//

import Foundation
import SwiftUI
import Factory
import Combine

@Observable
final class AddWorkoutSheetViewModel {
  
  @ObservationIgnored
  @Injected(\.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  
  var workoutName: String = ""
  var workoutType: String = ""
  var selectedExercises: [WorkoutExercise] = []
  var muscleSearchQuery: String = "" {
    didSet {
      self.searchQuerySubject.send(())
    }
  }
  var showRepsDialog: Bool = false
  var results: [Exercise] = []
  
  var state: LoadingViewState<[Exercise]> = .empty
  
  private(set) var loadTask: Task<Void, Never>?
  
  var didSaveSubject = PassthroughSubject<Bool, Never>()
  var searchQuerySubject = PassthroughSubject<Void, Never>()
  private var cancellables = Set<AnyCancellable>()
  
  var currentSelectedExercise: Exercise? = nil {
    didSet {
      if currentSelectedExercise != nil {
        showRepsDialog = true
      } else {
        showRepsDialog = false
      }
    }
  }
  
  private(set) var submitWorkoutTask: Task<Void, Never>?
  
  private let workoutDataStore: WorkoutDataStore
  
  
  init(dataStore: WorkoutDataStore = WorkoutDataStore()) {
    self.workoutDataStore = dataStore
    
    searchQuerySubject
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { [weak self] _ in
        guard let self else { return }
        self.searchByMuscleName(self.muscleSearchQuery)
      }
      .store(in: &cancellables)
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
    loadTask?.cancel()
    loadTask = nil
    
    submitWorkoutTask?.cancel()
    submitWorkoutTask = nil
  }
}

// MARK: - Data Store

extension AddWorkoutSheetViewModel {
  func initialLoad() {
    loadTask = Task { @MainActor in
      let results = await exerciseDataStore.getAll(fetchLimit: 10)
      self.results = results
    }
  }
  
  func searchByMuscleName(_ name: String) {
    loadTask?.cancel()
    
    loadTask = Task { @MainActor in
      let results = await exerciseDataStore.getByName(name)
      self.results = results
    }
  }
  
  
  func submitWorkout() {
    guard !selectedExercises.isEmpty, !workoutName.isEmpty, !muscleSearchQuery.isEmpty else { return }
    
    submitWorkoutTask = Task {
      let workout = Workout(
        name: self.workoutName,
        targetMuscles: [self.muscleSearchQuery],
        workoutType: self.workoutType,
        workoutExercises: self.selectedExercises
      )
      
      do {
        try await self.workoutDataStore.create(workout)
        await MainActor.run {
          self.didSaveSubject.send(true)
        }
      } catch {
        await MainActor.run {
          self.didSaveSubject.send(false)
        }
        MusculosLogger.logError(error, message: "Could not add workout", category: .coreData)
      }
    }
  }
}
