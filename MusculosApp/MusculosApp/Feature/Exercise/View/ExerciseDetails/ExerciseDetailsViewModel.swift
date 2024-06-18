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

@Observable
final class ExerciseDetailsViewModel {
  
  // MARK: - Dependencies
  
  @ObservationIgnored
  @Injected(\.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol
  
  // MARK: - Observed properties
  
  private(set) var showChallengeExercise = false
  private(set) var isTimerActive = false
  private(set) var timer: Timer? = nil
  private(set) var elapsedTime: Int = 0
  
  var isFavorite = false
  
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
  
  func startTimer() {
    isTimerActive = true
    elapsedTime = 0
    
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
      self?.elapsedTime += 1
    })
    
    if let timer {
      RunLoop.current.add(timer, forMode: .common)
    }
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
        await MainActor.run {
          didSaveFavoriteSubject.send(false)
        }
        MusculosLogger.logError(error, message: "Could not update exercise.isFavorite", category: .coreData)
      }
    }
  }
  
  func saveExerciseSession() {
    saveExerciseSessionTask?.cancel()
    
    saveExerciseSessionTask = Task { @MainActor in
      do {
        try await exerciseSessionDataStore.addSession(exercise, date: Date())
        didSaveSessionSubject.send(true)
      } catch {
        didSaveSessionSubject.send(false)
        MusculosLogger.logError(error, message: "Could not save exercise session", category: .coreData)
      }
    }
  }
}
