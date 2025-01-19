//
//  GoalRepositoryStub.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Foundation
import Models
import Utility
import Storage

public struct GoalRepositoryStub: GoalRepositoryProtocol {
  var expectedOnboardingGoals: [OnboardingGoal] = []
  var expectedGoals: [Goal] = []

  public init(expectedOnboardingGoals: [OnboardingGoal] = [], expectedGoals: [Goal] = []) {
    self.expectedOnboardingGoals = expectedOnboardingGoals
    self.expectedGoals = expectedGoals
  }

  public func getOnboardingGoals() async throws -> [OnboardingGoal] {
    expectedOnboardingGoals
  }

  public func getGoalDetails(_: UUID) async throws -> Goal? {
    expectedGoals.first
  }

  public func getGoals() async throws -> [Goal] {
    expectedGoals
  }

  public func addFromOnboardingGoal(_: OnboardingGoal, for _: UserProfile) async throws -> Goal {
    if let first = expectedGoals.first {
      return first
    }
    throw MusculosError.unexpectedNil
  }

  public func addGoal(_: Models.Goal) async throws { }

  public func updateGoalProgress(exerciseSession _: ExerciseSession) async throws { }

  public func goalsPublisher() -> FetchedResultsPublisher<GoalEntity> {
    StorageContainer.shared.coreDataStore().goalsPublisher()
  }
}
