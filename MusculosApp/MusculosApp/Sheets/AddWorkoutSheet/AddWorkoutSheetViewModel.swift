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
final class AddWorkoutSheetViewModel: BaseViewModel {

  // MARK: Dependencies

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.workoutRepository) private var workoutRepository: WorkoutRepositoryProtocol

  // MARK: Properties

  private var exercises: [Exercise] = []
  private let didSaveSubject = PassthroughSubject<Void, Never>()

  var workoutName = ""
  var workoutType = ""
  var selectedWorkoutExercise: [WorkoutExercise] = []

  var showSelectMuscles = true
  var showWorkoutType = false
  var showRepsDialog = false

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

    Task {
      exercises = await exerciseRepository.getExercisesForMuscleTypes(selectedMuscleTypes)
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

  func didSelectExercise(with _: Int = 0) {
    guard let exercise = currentSelectedExercise else {
      return
    }
    defer { currentSelectedExercise = nil }

    if let index = selectedWorkoutExercise.firstIndex(where: { $0.exercise == exercise }) {
      selectedWorkoutExercise.remove(at: index)
    } else {
//      selectedWorkoutExercise.append(WorkoutExercise(numberOfReps: numberOfReps, exercise: exercise))
    }
  }
}

// MARK: - Task

extension AddWorkoutSheetViewModel {
  func submitWorkout() {
    guard !selectedWorkoutExercise.isEmpty, !workoutName.isEmpty, !workoutType.isEmpty else {
      toastManager.showWarning("Cannot save workout with empty data")
      return
    }

    guard let currentUser else {
      assertionFailure("Current user shouldn't be nil")
      return
    }

    Task {
      do {
        let workout = Workout(
          name: workoutName,
          targetMuscles: selectedMuscles,
          workoutType: workoutType,
          createdBy: currentUser,
          workoutExercises: selectedWorkoutExercise)
        try await workoutRepository.addWorkout(workout)
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
