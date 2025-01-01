//
//  AddWorkoutSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.04.2024.
//

import Combine
import Components
import DataRepository
import Factory
import Foundation
import Models
import Storage
import SwiftUI
import Utility

// MARK: - AddWorkoutSheetViewModel

@Observable
@MainActor
final class AddWorkoutSheetViewModel {

  // MARK: Dependencies

  @ObservationIgnored
  @Injected(\.toastManager) private var toastManager: ToastManager

  @ObservationIgnored
  @Injected(\StorageContainer.coreDataStore) private var coreDataStore: CoreDataStore

  @ObservationIgnored
  @Injected(\StorageContainer.userManager) private var userManager: UserSessionManagerProtocol

  // MARK: Properties

  private(set) var submitWorkoutTask: Task<Void, Never>?
  private(set) var updateTask: Task<Void, Never>?
  private var exercises: [Exercise] = []
  private let didSaveSubject = PassthroughSubject<Void, Never>()

  var workoutName = ""
  var workoutType = ""
  var selectedWorkoutExercise: [WorkoutExercise] = []
  var showRepsDialog = false
  var showSelectMuscles = true

  var didSavePublisher: AnyPublisher<Void, Never> {
    didSaveSubject.eraseToAnyPublisher()
  }

  var currentSelectedExercise: Exercise? {
    didSet {
      if currentSelectedExercise != nil {
        showRepsDialog = true
      } else {
        showRepsDialog = false
      }
    }
  }

  var selectedMuscles: [String] = [] {
    didSet {
      updateExercises()
    }
  }

  var displayExercises: [Exercise] {
    guard !selectedWorkoutExercise.isEmpty else {
      return exercises
    }
    let selectedExercises = selectedWorkoutExercise.compactMap { $0.exercise }
    let remainingExercises = exercises.filter { !selectedExercises.contains($0) }
    return selectedExercises + remainingExercises
  }

  var selectedMuscleTypes: [MuscleType] {
    selectedMuscles.compactMap { MuscleType(rawValue: $0) }
  }

  private func updateExercises() {
    guard !selectedMuscles.isEmpty else {
      return
    }

    updateTask = Task {
      exercises = await coreDataStore.exercisesForMuscles(selectedMuscleTypes)
    }
  }

  // MARK: - UI Logic

  func isExerciseSelected(_ exercise: Exercise) -> Bool {
    selectedWorkoutExercise.contains(where: { $0.exercise == exercise })
  }

  func willSelectExercise(_ exercise: Exercise) {
    let selectedExercises = selectedWorkoutExercise.compactMap(\.exercise)
    if let firstIndex = selectedExercises.firstIndex(where: { $0 == exercise }) {
      selectedWorkoutExercise.remove(at: firstIndex)
    } else {
      currentSelectedExercise = exercise
    }
  }

  func didSelectExercise(with numberOfReps: Int = 0) {
    guard let exercise = currentSelectedExercise else {
      return
    }
    defer { currentSelectedExercise = nil }

    if let index = selectedWorkoutExercise.firstIndex(where: { $0.exercise == exercise }) {
      selectedWorkoutExercise.remove(at: index)
    } else {
      selectedWorkoutExercise.append(WorkoutExercise(numberOfReps: numberOfReps, exercise: exercise))
    }
  }

  // MARK: - Clean up

  func cleanUp() {
    submitWorkoutTask?.cancel()
    submitWorkoutTask = nil

    updateTask?.cancel()
    updateTask = nil
  }
}

// MARK: - Data Store methods

extension AddWorkoutSheetViewModel {
  func submitWorkout() {
    guard !selectedWorkoutExercise.isEmpty, !workoutName.isEmpty, !workoutType.isEmpty else {
      toastManager.showWarning("Cannot save workout with empty data")
      return
    }

    submitWorkoutTask = Task { [weak self] in
      guard let self else {
        return
      }

      guard
        let currentUserID = userManager.currentUserID,
        let currentUserProfile = await coreDataStore.userProfile(for: currentUserID)
      else {
        handleError(MusculosError.unexpectedNil, message: "Invalid user")
        return
      }

      do {
        let workout = Workout(
          name: workoutName,
          targetMuscles: selectedMuscles,
          workoutType: workoutType,
          createdBy: currentUserProfile,
          workoutExercises: selectedWorkoutExercise)
        try await coreDataStore.insertWorkout(workout)
        didSaveSubject.send(())
      } catch {
        handleError(error, message: "Error adding workout")
      }
    }
  }

  private func handleError(_ error: Error, message: String) {
    toastManager.showError(message)
    Logger.error(error, message: message)
  }
}
