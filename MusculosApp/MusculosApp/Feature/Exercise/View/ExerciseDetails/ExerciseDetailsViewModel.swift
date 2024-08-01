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

  // MARK: - Observed properties
  
  private(set) var isFavorite = false
  private(set) var showChallengeExercise = false
  private(set) var isTimerActive = false
  private(set) var timer: Timer? = nil
  private(set) var elapsedTime: Int = 0
  
  // MARK: - Publishers
  
  private var cancellables = Set<AnyCancellable>()
  private(set) var favoriteSubject = PassthroughSubject<Bool, Never>()
  private(set) var didSaveSessionSubject = PassthroughSubject<Bool, Never>()
  private(set) var didSaveFavoriteSubject = PassthroughSubject<Bool, Never>()
  
  // MARK: - Tasks
  
  private(set) var markFavoriteTask: Task<Void, Never>?
  private(set) var saveExerciseSessionTask: Task<Void, Never>?
  
  // MARK: - Init and Setup
  
  let exercise: Exercise
  
  init(exercise: Exercise) {
    self.exercise = exercise
    self.setupPublishers()
  }
  
  /// Add a short debounce for `favoriteSubject` in case the favorite button is spammed
  ///
  private func setupPublishers() {
    favoriteSubject
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { [weak self] isFavorite in
        self?.updateFavorite(isFavorite)
      }
      .store(in: &cancellables)
  }
  
  func toggleIsFavorite() {
    isFavorite.toggle()
    favoriteSubject.send(isFavorite)
  }
  
  // MARK: - Timer
  
  private(set) var timerTask: Task<Void, Never>?
  
  func startTimer() {
    isTimerActive = true
    elapsedTime = 0
    
    timerTask = Task { [weak self] in
      guard let self else { return }
      
      repeat {
        guard !Task.isCancelled, ((try? await Task.sleep(for: .seconds(1))) != nil) else { break }
      
        self.elapsedTime += 1
      } while isTimerActive
    }
  }
  
  private func incrementTime() {
    elapsedTime += 1
  }
  
  func stopTimer() {
    saveExerciseSession()
    isTimerActive = false
    
    timer?.invalidate()
    timer = nil
  }
  
  // MARK: - Clean up
  
  func cleanUp() {
    markFavoriteTask?.cancel()
    markFavoriteTask = nil
    
    saveExerciseSessionTask?.cancel()
    saveExerciseSessionTask = nil
    
    timer?.invalidate()
    timer = nil
  }
}

// MARK: - Data store methods

extension ExerciseDetailsViewModel {
  
  @MainActor
  func initialLoad() async {
    isFavorite = await exerciseDataStore.isFavorite(exercise)
  }
  
  func updateFavorite(_ isFavorite: Bool) {
    markFavoriteTask?.cancel()
    
    markFavoriteTask = Task { @MainActor in
      do {
        try await exerciseDataStore.setIsFavorite(exercise, isFavorite: isFavorite)
        didSaveFavoriteSubject.send(true)
      } catch {
        didSaveFavoriteSubject.send(false)
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
          self.didSaveSessionSubject.send(true)
        }
      } catch {
        MusculosLogger.logError(error, message: "Could not save exercise session", category: .coreData)
        
        await MainActor.run {
          self.didSaveSessionSubject.send(true)
        }
      }
    }
  }
  
  private func maybeUpdateGoals() async throws {
    let goals = await goalDataStore.getAll()
    
    for goal in goals {
      if let _ = ExerciseHelper.goalToExerciseCategories[goal.category] {
        try await goalDataStore.incrementCurrentValue(goal)
      }
    }
    
  }
}
