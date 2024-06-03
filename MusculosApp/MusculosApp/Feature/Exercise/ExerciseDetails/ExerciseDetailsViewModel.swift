//
//  ExerciseDetailsViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.05.2024.
//

import Foundation
import Factory
import SwiftUI

final class ExerciseDetailsViewModel: ObservableObject {
  @Injected(\.exerciseDataStore) private var exerciseDataStore
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore
  
  @Published  private(set) var isFavorite = false
  @Published  private(set) var showChallengeExercise = false
  @Published  private(set) var isTimerActive = false
  @Published  private(set) var timer: Timer? = nil
  @Published  private(set) var elapsedTime: Int = 0
  
  private(set) var isFavoriteTask: Task<Void, Never>?
  private(set) var saveExerciseSessionTask: Task<Void, Never>?
  
  let exercise: Exercise
  
  init(exercise: Exercise) {
    self.exercise = exercise
  }
  
  @MainActor
  func initialLoad() {
    Task { isFavorite = await exerciseDataStore.isFavorite(exercise) }
  }
  
  func toggleIsFavorite() {
    isFavorite.toggle()
    
    isFavoriteTask = Task.detached { [weak self] in
      guard let self else { return }
      
      do {
        try await self.exerciseDataStore.setIsFavorite(self.exercise, isFavorite: self.isFavorite)
      } catch {
        MusculosLogger.logError(error, message: "Could not update exercise.isFavorite", category: .coreData)
      }
    }
  }
  
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
  
  func saveExerciseSession() {
    saveExerciseSessionTask = Task.detached { [weak self] in
      guard let self else { return }
      
      do {
        try await self.exerciseSessionDataStore.add(from: self.exercise, date: Date())
      } catch {
        MusculosLogger.logError(error, message: "Could not save exercise session", category: .coreData)
      }
    }
  }
  
  func cleanUp() {
    isFavoriteTask?.cancel()
    isFavoriteTask = nil
    
    timer?.invalidate()
    timer = nil
  }
}
