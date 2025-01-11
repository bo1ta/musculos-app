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

  // MARK: Dependencies

  @ObservationIgnored
  @Injected(\.currentUser) private var currentUser: UserProfile?

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepositoryProtocol

  // MARK: Public

  private(set) var saveTask: Task<Void, Never>?
  private(set) var didSavePublisher = PassthroughSubject<Void, Never>()

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

  func saveGoal() {
    saveTask = Task {
      guard let currentUser else {
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

  func cancelTask() {
    saveTask?.cancel()
    saveTask = nil
  }
}
