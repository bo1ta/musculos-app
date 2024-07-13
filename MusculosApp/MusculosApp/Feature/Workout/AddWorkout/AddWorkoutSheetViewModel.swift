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

import Models
import Utility
import Storage

@Observable
@MainActor
final class AddWorkoutSheetViewModel {
  
  // MARK: - Dependencies
  
  @ObservationIgnored
//  @Injected(\.dataStore) private var dataStore: DataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.workoutDataStore) private var workoutDataStore: WorkoutDataStoreProtocol
  
  // MARK: - Observed properties
  
  var workoutName: String = ""
  var workoutType: String = ""
  var selectedExercises: [WorkoutExercise] = []
  var showRepsDialog: Bool = false
  var selectedMuscles: [String] = [] {
    didSet {
      musclesChanged.send(())
    }
  }
  var showSelectMuscles = true
  
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
  
  var selectedMuscleTypes: [MuscleType] {
    return selectedMuscles.compactMap { MuscleType(rawValue: $0) }
  }
  
  var state: LoadingViewState<[Exercise]> = .empty
  
  // MARK: - Subjects
  
  var didSaveSubject = PassthroughSubject<Bool, Never>()
  var searchQuerySubject = PassthroughSubject<Void, Never>()
  var musclesChanged = PassthroughSubject<Void, Never>()
  
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Tasks
  
  private(set) var loadTask: Task<Void, Never>?
  private(set) var submitWorkoutTask: Task<Void, Never>?
  private(set) var updateTask: Task<Void, Never>?
  
  // MARK: - Init and setup
  
  init() {
    setupPublishers()
  }
  
  private func setupPublishers() {
    searchQuerySubject
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { [weak self] _ in
        guard let self else { return }
        self.searchByMuscleName(self.muscleSearchQuery)
      }
      .store(in: &cancellables)
    
    musclesChanged
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { [weak self] _ in
        guard let self else { return }
        self.updateExercises()
      }
      .store(in: &cancellables)
    
  }
  
  private func updateExercises() {
    guard !selectedMuscles.isEmpty else { return }
    
    updateTask = Task {
      state = .loading
      
//      let results = await dataStore.exerciseDataStore.getByMuscles(selectedMuscleTypes)
//      state = .loaded(results)
    }
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
    
    updateTask?.cancel()
    updateTask = nil
  }
}

// MARK: - Data Store methods

extension AddWorkoutSheetViewModel {
  func initialLoad() {
    loadTask = Task { @MainActor in
      state = .loading
      
//      let results = await dataStore.loadExercises(fetchLimit: 20)
//      if results.isEmpty {
//        state = .empty
//      } else {
//        state = .loaded(results)
//      }
    }
  }
  
  func searchByMuscleName(_ name: String) {
    loadTask?.cancel()
    
    loadTask = Task { @MainActor in
      state = .loading
      
//      let results = await dataStore.exerciseDataStore.getByName(name)
//      if results.isEmpty {
//        state = .empty
//      } else {
//        state = .loaded(results)
//      }
    }
  }
  
  
  func submitWorkout() {
    guard !selectedExercises.isEmpty, !workoutName.isEmpty, !muscleSearchQuery.isEmpty else { return }
    
    submitWorkoutTask = Task {
      
      guard let userSession = await UserSessionActor.shared.currentUser() else { return }
      
      let workout = Workout(
        name: self.workoutName,
        targetMuscles: [self.muscleSearchQuery],
        workoutType: self.workoutType,
        workoutExercises: self.selectedExercises
      )
      
      do {
        try await self.workoutDataStore.create(workout, userId: userSession.userId)
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
