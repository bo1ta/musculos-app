//
//  GoalRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 26.10.2024.
//

import Factory
import Foundation
import Models
import NetworkClient
import Storage
import Utility

// MARK: - GoalRepositoryProtocol

public protocol GoalRepositoryProtocol: Sendable {
  func getOnboardingGoals() async throws -> [OnboardingGoal]
  func addGoal(_ goal: Goal) async throws
  func getGoalDetails(_ goalID: UUID) async throws -> Goal?
  func getGoals() async throws -> [Goal]
  func addFromOnboardingGoal(_ onboardingGoal: OnboardingGoal, for user: UserProfile) async throws -> Goal
  func updateGoalProgress(exerciseSession: ExerciseSession) async throws
}

// MARK: - GoalRepository

public struct GoalRepository: @unchecked Sendable, BaseRepository, GoalRepositoryProtocol {
  @Injected(\NetworkContainer.goalService) private var service: GoalServiceProtocol

  public init() { }

  public func getOnboardingGoals() async throws -> [OnboardingGoal] {
    try await service.getOnboardingGoals()
  }

  public func addGoal(_ goal: Goal) async throws {
    try await update(
      localTask: { try await coreDataStore.importModel(goal, of: GoalEntity.self) },
      remoteTask: { try await service.addGoal(goal) })
  }

  public func getGoalDetails(_ goalID: UUID) async throws -> Goal? {
    try await fetch(
      forType: GoalEntity.self,
      localTask: { await coreDataStore.goalByID(goalID) },
      remoteTask: { try await service.getGoalByID(goalID) })
  }

  public func getGoals() async throws -> [Goal] {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }
    return try await fetch(
      forType: GoalEntity.self,
      localTask: { await coreDataStore.userProfileByID(currentUserID)?.goals ?? [] },
      remoteTask: { try await service.getUserGoals() })
  }

  public func addFromOnboardingGoal(_ onboardingGoal: OnboardingGoal, for user: UserProfile) async throws -> Goal {
    let goal = Goal(
      id: onboardingGoal.id,
      name: onboardingGoal.title,
      category: onboardingGoal.description,
      frequency: .daily,
      targetValue: 15,
      endDate: nil,
      dateAdded: Date(),
      user: user)

    try await update(
      localTask: { try await coreDataStore.importModel(goal, of: GoalEntity.self) },
      remoteTask: { try await service.addGoal(goal) })

    return goal
  }

  public func updateGoalProgress(exerciseSession: ExerciseSession) async throws {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }
    try await coreDataStore.updateGoalProgress(userID: currentUserID, exerciseSession: exerciseSession)
  }
}
