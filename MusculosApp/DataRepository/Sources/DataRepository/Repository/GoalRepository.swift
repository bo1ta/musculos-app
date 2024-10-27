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

public actor GoalRepository: BaseRepository {
  @Injected(\NetworkContainer.goalService) private var service: GoalServiceProtocol
  @Injected(\StorageContainer.goalDataStore) private var dataStore: GoalDataStoreProtocol
  @Injected(\DataRepositoryContainer.backgroundWorker) private var backgroundWorker: BackgroundWorker

  public init() {}

  public func getOnboardingGoals() async throws -> [OnboardingGoal] {
    return try await service.getOnboardingGoals()
  }

  public func addGoal(_ goal: Goal) async throws {
    try await dataStore.add(goal)

    backgroundWorker.queueOperation(priority: .low, operationType: .remote) { [weak self] in
      try await self?.service.addGoal(goal)
    }
  }

  public func getGoalDetails(_ goalID: UUID) async throws -> Goal? {
    let goal = await dataStore.getByID(goalID)

    let backgroundTask = backgroundWorker.queueOperation(priority: .low, operationType: .remote) { [weak self] in
      return try await self?.service.getGoalByID(goalID)
    }

    if let goal {
      return goal
    } else {
      return try await backgroundTask.value
    }
  }

  public func getGoals() async throws -> [Goal] {
    let goals = await dataStore.getAll()
    if goals.count > 0 {
      return goals
    }

    let remoteGoals = try await service.getUserGoals()
    backgroundWorker.queueOperation(priority: .high, operationType: .local) { [weak self] in
      try await self?.dataStore.importToStorage(remoteObjects: remoteGoals, localObjectType: GoalEntity.self)
    }
    return remoteGoals
  }

  public func addFromOnboardingGoal(_ onboardingGoal: OnboardingGoal, for user: UserProfile) async throws -> Goal {
    let goal = Goal(
      name: onboardingGoal.title, category: onboardingGoal.description, frequency: .daily, targetValue: 15, endDate: nil, dateAdded: Date(), user: user)

    try await dataStore.add(goal)
    try await service.addGoal(goal)

    return goal
  }
}
