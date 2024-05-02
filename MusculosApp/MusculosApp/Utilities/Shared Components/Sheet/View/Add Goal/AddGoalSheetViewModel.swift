//
//  AddGoalSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI

final class AddGoalSheetViewModel: ObservableObject {
  @Published var name: String = ""
  @Published var category: String = ""
  @Published var showCategoryOptions: Bool = true
  @Published var targetValue: String = ""
  @Published var endDate: Date = Date()
  @Published var state: EmptyLoadingViewState = .empty
  
  private let dataStore: GoalDataStore
  
  private(set) var saveTask: Task<Void, Never>?
  
  init(dataStore: GoalDataStore = GoalDataStore()) {
    self.dataStore = dataStore
  }
  
  func saveGoal() {
    saveTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      let goal = Goal(
        name: self.name,
        category: Goal.GoalCategory(rawValue: self.category) ?? .general,
        targetValue: self.targetValue,
        endDate: self.endDate
      )
      
      await self.dataStore.add(goal)
      self.state = .successful
    }
  }
  
  func cleanUp() {
    saveTask?.cancel()
    saveTask = nil
  }
}
