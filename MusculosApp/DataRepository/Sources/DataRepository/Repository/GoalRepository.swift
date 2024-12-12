//
//  GoalRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 26.10.2024.
//

import Foundation
import Models
import Utility
import Storage
import NetworkClient
import Factory
import Utility

public actor GoalRepository: BaseRepository {
  @Injected(\NetworkContainer.goalService) private var service: GoalServiceProtocol
  @Injected(\StorageContainer.goalDataStore) private var dataStore: GoalDataStoreProtocol
  @Injected(\DataRepositoryContainer.backgroundWorker) private var backgroundWorker: BackgroundWorker

  private let updateThreshold: TimeInterval = .oneHour

  public init() {}

  public func getOnboardingGoals() async throws -> [OnboardingGoal] {
    return try await service.getOnboardingGoals()
  }

  public func addGoal(_ goal: Goal) async throws {
    try await dataStore.add(goal)

    backgroundWorker.queueOperation { [weak self] in
      try await self?.service.addGoal(goal)
    }
  }

  public func getGoalDetails(_ goalID: UUID) async throws -> Goal? {
    let goal = await dataStore.getByID(goalID)

    let backgroundTask = backgroundWorker.queueOperation { [weak self] in
      return try await self?.service.getGoalByID(goalID)
    }

    if let goal {
      return goal
    } else {
      return try await backgroundTask.value
    }
  }

  public func getGoals() async throws -> [Goal] {
    guard let currentUserID = self.currentUserID else {
      throw MusculosError.notFound
    }

    guard !shouldUseLocalStorage() else {
      return await dataStore.getAllForUser(currentUserID)
    }

    let goals = await dataStore.getAllForUser(currentUserID)
    backgroundWorker.queueOperation { [weak self] in
      try await self?.dataStore.importToStorage(models: goals, localObjectType: GoalEntity.self)
      await self?.dataStore.updateLastUpdated(Date())
    }

    return goals
  }

  public func addFromOnboardingGoal(_ onboardingGoal: OnboardingGoal, for user: UserProfile) async throws -> Goal {
    let goal = Goal(
      name: onboardingGoal.title,
      category: onboardingGoal.description,
      frequency: .daily,
      targetValue: 15,
      endDate: nil,
      dateAdded: Date(),
      user: user
    )

    try await dataStore.add(goal)
    try await service.addGoal(goal)

    return goal
  }

  private func shouldUseLocalStorage() -> Bool {
    guard let lastUpdated = dataStore.getLastUpdated() else {
      return false
    }
    return Date().timeIntervalSince(lastUpdated) < updateThreshold
  }
}
