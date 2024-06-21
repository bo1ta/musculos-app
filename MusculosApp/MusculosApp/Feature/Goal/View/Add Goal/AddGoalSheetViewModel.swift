//
//  AddGoalSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI
import Combine
import Factory

@Observable
final class AddGoalSheetViewModel {
  
  // MARK: - Dependency
  
  @ObservationIgnored
  @Injected(\.goalDataStore) private var dataStore: GoalDataStoreProtocol
  
  // MARK: - Observed properties
  
  var name: String = ""
  var category: String = ""
  var showCategoryOptions: Bool = true
  var targetValue: String = ""
  var showEndDate: Bool = true
  var showFrequencyOptions: Bool = true
  var endDate: Date = Date()
  
  var frequency: String = "" {
    didSet {
      if frequency == Goal.Frequency.fixedDate.description {
        DispatchQueue.main.async {
          self.showEndDate = true
        }
      }
    }
  }
  
  private(set) var didSaveGoalPublisher = PassthroughSubject<Bool, Never>()
  
  // MARK: - Tasks
  
  @ObservationIgnored
  private(set) var saveTask: Task<Void, Never>?

  func saveGoal() {
    saveTask = Task {
      let goal = Goal(
        name: name,
        category: Goal.Category.initFromLabel(self.category) ?? .general,
        frequency: Goal.Frequency(rawValue: self.frequency) ?? .daily,
        targetValue: Int(self.targetValue) ?? 5,
        endDate: endDate,
        dateAdded: Date()
      )
      
      do {
        try await dataStore.add(goal)
        
        await MainActor.run {
          didSaveGoalPublisher.send(true)
        }
      } catch {
        await MainActor.run {
          didSaveGoalPublisher.send(false)
        }
        MusculosLogger.logError(error, message: "Could not save goal", category: .coreData)
      }
    }
  }
  
  // MARK: - Clean up
  
  func cleanUp() {
    saveTask?.cancel()
    saveTask = nil
  }
}
