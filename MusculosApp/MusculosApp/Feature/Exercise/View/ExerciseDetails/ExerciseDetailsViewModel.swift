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
  
  // MARK: - Dependencies
  
  @ObservationIgnored
  @Injected(\.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.goalDataStore) private var goalDataStore: GoalDataStoreProtocol

  @ObservationIgnored
  @Injected(\.userManager) private var userManager: UserManagerProtocol

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
    isFavorite = await exerciseDataStore.isFavorite(exercise)
  }

  func updateFavorite(_ isFavorite: Bool) {
    markFavoriteTask?.cancel()

    markFavoriteTask = Task { [weak self] in
      guard let self else { return }

      do {
        // short debounce
        try await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }

        try await exerciseDataStore.setIsFavorite(exercise, isFavorite: isFavorite)
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
      guard let self, let currentUser = await userManager.currentSession() else {
        return
      }

      do {
        try await exerciseSessionDataStore.addSession(exercise, date: Date(), userId: currentUser.userId)
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
    let goals = await goalDataStore.getAll()

    for goal in goals {
      if let _ = ExerciseHelper.goalToExerciseCategories[goal.category] {
        try await goalDataStore.incrementCurrentValue(goal)
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
