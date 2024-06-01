//
//  ExploreExerciseViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 17.04.2024.
//

import Foundation
import SwiftUI
import Factory

final class ExploreExerciseViewModel: ObservableObject {
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol
  
  @Published var completedToday: [ExerciseSession] = []
  @Published var searchQuery = ""
  @Published var showFilterView = false
  @Published var showExerciseDetails = false
  @Published var selectedExercise: Exercise? = nil {
    didSet {
      if selectedExercise != nil {
        showExerciseDetails = true
      }
    }
  }
  
  private(set) var exerciseSessionTask: Task<Void, Never>?
  
  func loadExercisesCompletedToday() {
    exerciseSessionTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      do {
        let completedToday = try self.exerciseSessionDataStore.getCompletedToday()
        self.completedToday = completedToday
      } catch {
        MusculosLogger.logError(error, message: "Could not load exercise sessions completed today", category: .coreData)
      }
    }
  }
}
