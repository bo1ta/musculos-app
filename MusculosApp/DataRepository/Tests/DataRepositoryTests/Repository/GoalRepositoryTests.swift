//
//  GoalRepositoryTests.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Testing
import Factory
import Foundation
import XCTest

@testable import DataRepository
@testable import Storage
@testable import NetworkClient
@testable import Models
@testable import Utility

class GoalRepositoryTests: XCTestCase {
  @Injected(\StorageContainer.coreDataStore) private var coreDataStore

  func testGetOnboardingGoals() async throws {
    let expectation = self.expectation(description: "should get onboarding goals")
    let mockService = MockGoalService(expectation: expectation)

    NetworkContainer.shared.goalService.register { mockService }
    defer { NetworkContainer.shared.goalService.reset() }

    let results = try await GoalRepository().getOnboardingGoals()
    XCTAssertFalse(results.isEmpty)
    await fulfillment(of: [expectation])
  }

  func testGoalDetailsUsesService() async throws {
    let factory = GoalFactory()
    factory.isPersistent = false
    let expectedGoal = factory.create()
    let expectation = self.expectation(description: "should get goal details")
    let mockService = MockGoalService(expectation: expectation, expectedGoals: [expectedGoal])

    NetworkContainer.shared.goalService.register { mockService }
    defer { NetworkContainer.shared.goalService.reset() }

    let repository = GoalRepository()
    let result = try #require(try await repository.getGoalDetails(expectedGoal.id))
    XCTAssertEqual(result, expectedGoal)
    await fulfillment(of: [expectation])
  }

  func testAddFromOnboardingGoal() async throws {
    let user = UserProfileFactory.createUser()
    let onboardingGoal = OnboardingGoal(id: UUID(), title: "title", description: "description", iconName: "icomnName")

    let expectation = self.expectation(description: "should add goal")
    let mockService = MockGoalService(expectation: expectation)

    NetworkContainer.shared.goalService.register { mockService }
    defer { NetworkContainer.shared.goalService.reset() }

    let repository = GoalRepository()
    _ = try await repository.addFromOnboardingGoal(onboardingGoal, for: user)

    _ = try #require(await coreDataStore.goalByID(onboardingGoal.id))
    await fulfillment(of: [expectation])
  }
}

extension GoalRepositoryTests {
  private struct MockGoalService: GoalServiceProtocol {
    var expectation: XCTestExpectation?
    var expectedGoals: [Goal] = []

    func getOnboardingGoals() async throws -> [OnboardingGoal] {
      expectation?.fulfill()
      return [
        OnboardingGoal(id: UUID(), title: "Title 1", description: "description 1", iconName: "icon name")
      ]
    }
    
    func getUserGoals() async throws -> [Goal] {
      expectation?.fulfill()
      return expectedGoals
    }
    
    func addGoal(_ goal: Goal) async throws {
      expectation?.fulfill()
    }

    func getGoalByID(_ goalID: UUID) async throws -> Goal {
      expectation?.fulfill()

      if let first = expectedGoals.first {
        return first
      }
      throw MusculosError.unexpectedNil
    }
    
    func addProgressEntry(_ entry: Models.ProgressEntry) async throws {
      expectation?.fulfill()
    }
  }
}
