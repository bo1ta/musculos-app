//
//  ExerciseSessionStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.06.2024.
//

import Foundation
import SwiftUI
import Factory

final class ExerciseSessionStore: ObservableObject {
  @Injected(\.exerciseSessionDataStore)
  private var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol
  
  @Injected(\.goalDataStore)
  private var goalDataStore: GoalDataStoreProtocol
  
  @Published private(set) var goals: [Goal] = []
  @Published private(set) var exerciseSessions: [ExerciseSession] = []
  
  private let fetchedResultsController: ResultsController<ExerciseSessionEntity>
  
  private(set) var getGoalsTask: Task<Void, Never>?
  
  init() {
    self.fetchedResultsController = ResultsController<ExerciseSessionEntity>(storageManager: Container.shared.storageManager(), sortedBy: [])
    self.setUpFetchedResultsController()
  }
  
  func loadGoals() async {
    goals = await goalDataStore.getAll()
  }
}

// MARK: - Fetched Results Controller

extension ExerciseSessionStore {
  private func setUpFetchedResultsController() {
    fetchedResultsController.onDidChangeContent = { [weak self] in
      guard let updateLocalResults = self?.updateLocalResults else { return }
      Task {
        await updateLocalResults()
      }
    }
    
    fetchedResultsController.onDidResetContent = { [weak self] in
      guard let updateLocalResults = self?.updateLocalResults else { return }
      Task {
        await updateLocalResults()
      }
    }
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      MusculosLogger.logError(error, message: "Could not perform fetch for results controller!", category: .coreData)
    }
  }
  
  @MainActor
  private func updateLocalResults() {
    exerciseSessions = fetchedResultsController.fetchedObjects
  }
}
