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
import DataRepository

@Observable
@MainActor
final class AddGoalSheetViewModel {
  
  // MARK: - Dependency

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.userRepository) private var userRepository: UserRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepository

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

      guard let currentUser = await userRepository.getCurrentUser() else {
        return
      }

      let goal = Goal(
        name: name,
        category: self.category,
        frequency: Goal.Frequency(rawValue: self.frequency) ?? .daily,
        targetValue: Int(self.targetValue) ?? 5,
        endDate: endDate,
        dateAdded: Date(),
        user: currentUser
      )
      
      do {
        try await goalRepository.addGoal(goal)
        didSavePublisher.send(())
      } catch {
        Logger.error(error, message: "Could not save goal")
      }
    }
  }
  
  // MARK: - Clean up
  
  func cleanUp() {
    saveTask?.cancel()
    saveTask = nil
  }
}
