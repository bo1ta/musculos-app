//
//  OnboardingViewModelTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Combine
import Factory
import Fakery
import Foundation
import Models
import Testing
import XCTest

@testable import Components
@testable import DataRepository
@testable import MusculosApp
@testable import Storage

// MARK: - OnboardingViewModelTests

@MainActor
class OnboardingViewModelTests: XCTestCase {
  func testInitialLoad() async throws {
    let goalRepositoryStub = GoalRepositoryStub(expectedOnboardingGoals: [
      OnboardingGoal(
        id: UUID(),
        title: "title",
        description: "description",
        iconName: "icon"),
    ])
    DataRepositoryContainer.shared.goalRepository.register { goalRepositoryStub }
    defer { DataRepositoryContainer.shared.goalRepository.reset() }

    let viewModel = OnboardingViewModel()
    await viewModel.initialLoad()

    XCTAssertEqual(viewModel.onboardingGoals.count, 1)
  }

  func testHandleNextStep() async throws {
    let user = UserProfileFactory.createUser()
    let userHandlerStub = CurrentUserHandlerStub()

    let eventExpectation = self.expectation(description: "should publish didOnboarding event")
    let cancellable = userHandlerStub.eventPublisher.sink { event in
      XCTAssertEqual(event, .didFinishOnboarding)
      eventExpectation.fulfill()
    }
    defer { cancellable.cancel() }

    DataRepositoryContainer.shared.currentUserHandler.register { userHandlerStub }
    defer { DataRepositoryContainer.shared.currentUserHandler.reset() }

    let viewModel = OnboardingViewModel()
    XCTAssertEqual(viewModel.wizardStep, .heightAndWeight)

    viewModel.handleNextStep()
    XCTAssertEqual(viewModel.wizardStep, .level)

    viewModel.handleNextStep()
    XCTAssertEqual(viewModel.wizardStep, .goal)

    viewModel.handleNextStep()
    XCTAssertEqual(viewModel.wizardStep, .permissions)

    // will submit onboarding data
    viewModel.handleNextStep()

    let onboardingTask = try XCTUnwrap(viewModel.onboardingTask)
    await onboardingTask.value

    await fulfillment(of: [eventExpectation], timeout: 0.1)
  }
}
