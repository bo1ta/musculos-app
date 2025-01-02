//
//  AddGoalSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Combine
import DataRepository
import Factory
import Foundation
import Models
import Storage
import SwiftUI
import Utility

@Observable
@MainActor
final class AddGoalSheetViewModel {
  // MARK: - Dependency

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.userStore) private var userStore: UserStoreProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepositoryProtocol

  // MARK: - Observed properties

  var name = ""
  var category = ""
  var showCategoryOptions = true
  var targetValue = ""
  var showEndDate = true
  var showFrequencyOptions = true
  var endDate = Date()

  var frequency = "" {
    didSet {
      if frequency == Goal.Frequency.fixedDate.description {
        showEndDate = true
      }
    }
  }

  private(set) var didSavePublisher = PassthroughSubject<Void, Never>()

  // MARK: - Tasks

  @ObservationIgnored private(set) var saveTask: Task<Void, Never>?

  func saveGoal() {
    saveTask = Task { [weak self] in
      guard let self else {
        return
      }

      guard let currentUser = userStore.currentUser else {
        return
      }

      let goal = Goal(
        name: name,
        category: category,
        frequency: Goal.Frequency(rawValue: frequency) ?? .daily,
        targetValue: Int(targetValue) ?? 5,
        endDate: endDate,
        dateAdded: Date(),
        user: currentUser)

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
