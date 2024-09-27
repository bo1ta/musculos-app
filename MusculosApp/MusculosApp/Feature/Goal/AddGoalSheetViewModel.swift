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
import Models
import Utility
import Storage

@Observable
@MainActor
final class AddGoalSheetViewModel {
  
  // MARK: - Dependency
  
  @ObservationIgnored
  @Injected(\StorageContainer.dataController) private var dataController: DataController

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
        self.showEndDate = true
      }
    }
  }
  
  private(set) var didSavePublisher = PassthroughSubject<Void, Never>()

  // MARK: - Tasks
  
  @ObservationIgnored
  private(set) var saveTask: Task<Void, Never>?

  func saveGoal() {
    saveTask = Task { [weak self] in
      guard let self else { return }

      guard let currentUser = await dataController.getCurrentUserProfile() else {
        return
      }

      let goal = Goal(
        name: name,
        category: Goal.Category.initFromLabel(self.category) ?? .general,
        frequency: Goal.Frequency(rawValue: self.frequency) ?? .daily,
        targetValue: Int(self.targetValue) ?? 5,
        endDate: endDate,
        dateAdded: Date(),
        user: currentUser
      )
      
      do {
        try await dataController.addGoal(goal)
        didSavePublisher.send(())
      } catch {
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
