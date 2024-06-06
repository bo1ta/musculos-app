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
  @Injected(\.goalDataStore) private var goalDataStore: GoalDataStoreProtocol
  
  @Published var completedToday: [ExerciseSession] = []
  @Published var goals: [Goal] = []
  @Published var isLoading = false
  
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
    
  @MainActor
  func loadExercisesCompletedToday() async {
    self.completedToday = await exerciseSessionDataStore.getCompletedToday()
  }
  
  @MainActor
  func loadGoals() async {
    self.goals = await goalDataStore.getAll()
  }
  
  func initialLoad() async {
    await withTaskGroup(of: Void.self) { @MainActor [weak self] group in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      group.addTask { await self.loadExercisesCompletedToday() }
      group.addTask { await self.loadGoals() }
      
      await group.waitForAll()
    }
  }
}
