//
//  ExerciseDetailsViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.05.2024.
//

import Foundation
import Factory
import Combine
import SwiftUI
import Models
import Storage
import Utility

@Observable
@MainActor
final class ExerciseDetailsViewModel {

  @ObservationIgnored
  @Injected(\.dataController) private var dataController: DataController


  // MARK: - Event

  enum Event {
    case didSaveSession
    case didSaveSessionFailure(Error)
    case didUpdateFavorite(Exercise, Bool)
    case didUpdateFavoriteFailure(Error)
  }

  // MARK: - Observed properties

  private(set) var showChallengeExercise = false
  private(set) var isTimerActive = false
  private(set) var elapsedTime: Int = 0

  var isFavorite = false {
    didSet {
      updateFavorite(isFavorite)
    }
  }

  // MARK: - Publishers

  private let _event = PassthroughSubject<Event, Never>()

  var event: AnyPublisher<Event, Never> {
    _event.eraseToAnyPublisher()
  }

  // MARK: - Tasks
  
  private(set) var markFavoriteTask: Task<Void, Never>?
  private(set) var saveExerciseSessionTask: Task<Void, Never>?
  private(set) var timerTask: Task<Void, Never>?

  // MARK: - Init and Setup
  
  let exercise: Exercise
  
  init(exercise: Exercise) {
    self.exercise = exercise
  }

  // MARK: - Public methods

  func initialLoad() async {
    isFavorite = await dataController.isExerciseFavorite(exercise)
  }

  func updateFavorite(_ isFavorite: Bool) {
    markFavoriteTask?.cancel()

    markFavoriteTask = Task { [weak self] in
      guard let self else { return }

      do {
        // short debounce
        try await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }

        try await dataController.updateIsFavoriteForExercise(exercise, isFavorite: isFavorite)
        _event.send(.didUpdateFavorite(exercise, isFavorite))
      } catch {
        self.isFavorite = !isFavorite
        _event.send(.didUpdateFavoriteFailure(error))
        MusculosLogger.logError(error, message: "Could not update exercise.isFavorite", category: .coreData)
      }
    }
  }

  func saveExerciseSession() {
    saveExerciseSessionTask = Task.detached(priority: .background) { [weak self] in
      guard let self else { return }

      do {
        try await dataController.addExerciseSession(for: exercise, date: Date())
        try await maybeUpdateGoals()

        await MainActor.run {
          self._event.send(.didSaveSession)
        }
      } catch {
        MusculosLogger.logError(error, message: "Could not save exercise session", category: .coreData)

        await MainActor.run {
          self._event.send(.didSaveSessionFailure(error))
        }
      }
    }
  }

  func startTimer() {
    isTimerActive = true
    elapsedTime = 0
    
    timerTask = Task { [weak self, isTimerActive] in
      while isTimerActive {
        try? await Task.sleep(for: .seconds(1))
        await MainActor.run {
          self?.elapsedTime += 1
        }
      }
    }
  }
  
  func stopTimer() {
    isTimerActive = false
    timerTask?.cancel()
    timerTask = nil

    saveExerciseSession()
  }

  private func maybeUpdateGoals() async throws {
    let goals = try await dataController.getGoals()

    for goal in goals {
      if let _ = ExerciseHelper.goalToExerciseCategories[goal.category] {
        try await dataController.incrementGoalScore(goal)
      }
    }
  }

  // MARK: - Clean up
  
  func cleanUp() {
    markFavoriteTask?.cancel()
    markFavoriteTask = nil
    
    saveExerciseSessionTask?.cancel()
    saveExerciseSessionTask = nil
    
    timerTask?.cancel()
    timerTask = nil
  }
}
