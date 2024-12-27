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
import DataRepository
import Storage

@Observable
@MainActor
final class AddWorkoutSheetViewModel {

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepository

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

  private(set) var exercises: [Exercise] = []

  // MARK: - Subjects
  
  let didSaveSubject = PassthroughSubject<Void, Never>()
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
    musclesChanged
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { [weak self] _ in
        self?.updateExercises()
      }
      .store(in: &cancellables)
  }
  
  private func updateExercises() {
    guard !selectedMuscles.isEmpty else { return }
    
    updateTask = Task {
      exercises = await exerciseRepository.getExercisesForMuscleTypes(selectedMuscleTypes)
    }
  }
  
  // MARK: - UI Logic

  func isExerciseSelected(_ exercise: Exercise) -> Bool {
    return selectedExercises.first(where: { $0.exercise == exercise }) != nil
  }
  
  func didSelectExercise(with numberOfReps: Int = 0) {
    guard let exercise = currentSelectedExercise else {
      return
    }
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
  func submitWorkout() {
//    guard !selectedExercises.isEmpty, !workoutName.isEmpty, !muscleSearchQuery.isEmpty else { return }
//
//    guard let currentUserID = userManager.currentUserID else { return }
//
//    submitWorkoutTask = Task { [weak self] in
//      guard let self else { return }
//
//      let workout = Workout(
//        name: self.workoutName,
//        targetMuscles: [self.muscleSearchQuery],
//        workoutType: self.workoutType,
//        workoutExercises: self.selectedExercises
//      )
//      
//      do {
//        try await workoutDataStore.create(workout, userId: currentUserID)
//        didSaveSubject.send(())
//      } catch {
//        Logger.logError(error, message: "Could not add workout")
//      }
//    }
  }
}
