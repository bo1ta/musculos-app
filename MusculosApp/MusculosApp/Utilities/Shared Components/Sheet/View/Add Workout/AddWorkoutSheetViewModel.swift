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
  
  // MARK: - Dependencies
  
  @ObservationIgnored
  @Injected(\.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.workoutDataStore) private var workoutDataStore: WorkoutDataStoreProtocol
  
  // MARK: - Observed properties
  
  var workoutName: String = ""
  var workoutType: String = ""
  var selectedExercises: [WorkoutExercise] = []
  var showRepsDialog: Bool = false
  
  var muscleSearchQuery: String = "" {
    didSet {
      self.searchQuerySubject.send(())
    }
  }
  
  var currentSelectedExercise: Exercise? = nil {
    didSet {
      if currentSelectedExercise != nil {
        showRepsDialog = true
      } else {
        showRepsDialog = false
      }
    }
  }
  
  var state: LoadingViewState<[Exercise]> = .empty
  
  // MARK: - Subjects
  
  var didSaveSubject = PassthroughSubject<Bool, Never>()
  var searchQuerySubject = PassthroughSubject<Void, Never>()
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Tasks
  
  private(set) var loadTask: Task<Void, Never>?
  private(set) var submitWorkoutTask: Task<Void, Never>?
  
  // MARK: - Init and setup
  
  init() {
    setupPublisher()
  }
  
  private func setupPublisher() {
    searchQuerySubject
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { [weak self] _ in
        guard let self else { return }
        self.searchByMuscleName(self.muscleSearchQuery)
      }
      .store(in: &cancellables)
  }
  
  // MARK: - UI Logic

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
  
  // MARK: - Clean up
  
  func cleanUp() {
    loadTask?.cancel()
    loadTask = nil
    
    submitWorkoutTask?.cancel()
    submitWorkoutTask = nil
  }
}

// MARK: - Data Store methods

extension AddWorkoutSheetViewModel {
  func initialLoad() {
    loadTask = Task { @MainActor in
      state = .loading
      
      let results = await exerciseDataStore.getAll(fetchLimit: 10)
      if results.isEmpty {
        state = .empty
      } else {
        state = .loaded(results)
      }
    }
  }
  
  func searchByMuscleName(_ name: String) {
    loadTask?.cancel()
    
    loadTask = Task { @MainActor in
      state = .loading
      
      let results = await exerciseDataStore.getByName(name)
      if results.isEmpty {
        state = .empty
      } else {
        state = .loaded(results)
      }
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
