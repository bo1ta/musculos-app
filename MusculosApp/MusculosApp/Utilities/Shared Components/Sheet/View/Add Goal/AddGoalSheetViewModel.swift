//
//  AddGoalSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI
import Combine

@Observable
final class AddGoalSheetViewModel {
  var name: String = ""
  var category: String = ""
  var showCategoryOptions: Bool = true
  var targetValue: String = ""
  var showEndDate: Bool = false
  var showFrequencyOptions: Bool = true
  var frequency: String = "" {
    didSet {
      if frequency == Goal.Frequency.fixedDate.description {
        DispatchQueue.main.async {
          self.showEndDate = true
        }
      }
    }
  }
  var endDate: Date = Date()
  
  private let dataStore: GoalDataStore
  
  private(set) var saveTask: Task<Void, Never>?
  private(set) var didSaveGoalPublisher = PassthroughSubject<Bool, Never>()
  
  init(dataStore: GoalDataStore = GoalDataStore()) {
    self.dataStore = dataStore
  }
  
  func saveGoal() {
    saveTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      let goal = Goal(
        name: self.name,
        category: Goal.Category(rawValue: self.category) ?? .general,
        frequency: Goal.Frequency(rawValue: self.frequency) ?? .daily,
        targetValue: self.targetValue,
        endDate: self.endDate
      )
      
      do {
        try await self.dataStore.add(goal)
        self.didSaveGoalPublisher.send(true)
      } catch {
        self.didSaveGoalPublisher.send(false)
        MusculosLogger.logError(error, message: "Could not save goal", category: .coreData)
      }
    }
  }
  
  func cleanUp() {
    saveTask?.cancel()
    saveTask = nil
  }
}
