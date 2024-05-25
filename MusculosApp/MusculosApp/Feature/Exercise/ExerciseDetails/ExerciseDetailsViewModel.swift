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
  @Injected(\.exerciseDataStore) private var dataStore
  
  @Published  private(set) var isFavorite = false
  @Published  private(set) var showChallengeExercise = false
  @Published  private(set) var isTimerActive = false
  @Published  private(set) var timer: Timer? = nil
  @Published  private(set) var elapsedTime: Int = 0
  
  private(set) var isFavoriteTask: Task<Void, Never>?
  
  let exercise: Exercise
  
  init(exercise: Exercise) {
    self.exercise = exercise
  }
  
  @MainActor
  func initialLoad() {
    isFavorite = dataStore.isFavorite(exercise)
  }
  
  func toggleIsFavorite() {
    isFavorite.toggle()
    
    isFavoriteTask = Task { [weak self] in
      guard let self else { return }
      await self.dataStore.setIsFavorite(self.exercise, isFavorite: self.isFavorite)
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
    isTimerActive = false
    timer?.invalidate()
    timer = nil
  }
  
  func cleanUp() {
    isFavoriteTask?.cancel()
    isFavoriteTask = nil
    
    timer?.invalidate()
    timer = nil
  }
}
