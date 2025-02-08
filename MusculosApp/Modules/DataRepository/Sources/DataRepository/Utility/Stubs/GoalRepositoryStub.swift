//
//  GoalRepositoryStub.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Foundation
import Models
import Storage
import Utility

public struct GoalRepositoryStub: GoalRepositoryProtocol {
  var expectedOnboardingGoals: [OnboardingGoal] = []
  var expectedGoals: [Goal] = []
  var expectedUserID: UUID?

  public init(expectedOnboardingGoals: [OnboardingGoal] = [], expectedGoals: [Goal] = [], expectedUserID _: UUID? = nil) {
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
    GoalDataStore().goalsPublisherForUserID(expectedUserID ?? UUID())
  }
}
