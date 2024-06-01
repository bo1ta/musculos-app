//
//  AddGoalSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI
import Combine

final class AddGoalSheetViewModel: ObservableObject {
  @Published var name: String = ""
  @Published var category: String = ""
  @Published var showCategoryOptions: Bool = true
  @Published var targetValue: String = ""
  @Published var showEndDate: Bool = false
  @Published var showFrequencyOptions: Bool = true
  @Published var frequency: String = "" {
    didSet {
      if frequency == Goal.Frequency.fixedDate.description {
        DispatchQueue.main.async {
          self.showEndDate = true
        }
      }
    }
  }
  @Published var endDate: Date = Date()
  
  private let dataStore: GoalDataStore
  
  private(set) var saveTask: Task<Void, Never>?
  private(set) var didSaveGoalPublisher = PassthroughSubject<Void, Never>()
  
  init(dataStore: GoalDataStore = GoalDataStore()) {
    self.dataStore = dataStore
  }
  
  func saveGoal() {
    saveTask = Task.detached { [weak self] in
      guard let self else { return }
      
      let goal = Goal(
        name: self.name,
        category: Goal.Category(rawValue: self.category) ?? .general,
        frequency: Goal.Frequency(rawValue: self.frequency) ?? .daily,
        targetValue: self.targetValue,
        endDate: self.endDate
      )
      
      await self.dataStore.add(goal)
      await MainActor.run { self.didSaveGoalPublisher.send(()) }
    }
  }
  
  func cleanUp() {
    saveTask?.cancel()
    saveTask = nil
  }
}
