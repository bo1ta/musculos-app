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
  
  private let fetchedResultsController: ResultsController<ExerciseSessionEntity>
  
  private(set) var getGoalsTask: Task<Void, Never>?
  
  init() {
    self.fetchedResultsController = ResultsController<ExerciseSessionEntity>(storageManager: Container.shared.storageManager(), sortedBy: [])
  }
  
  func loadGoals() {
    
  }
  
}
