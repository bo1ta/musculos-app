//
//  AuthenticationViewModelTests.swift
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

// MARK: - AuthenticationViewModelTests

@MainActor
class AuthenticationViewModelTests: XCTestCase {
  private let faker = Faker()

  func testLoginFormIsValid() async throws {
    let viewModel = AuthenticationViewModel(initialStep: .login)
    #expect(viewModel.isLoginFormValid == false)

    viewModel.email = faker.internet.email()
    viewModel.password = faker.internet.password()
    #expect(viewModel.isLoginFormValid == true)
  }

  func testRegisterFormIsValid() async throws {
    let viewModel = AuthenticationViewModel(initialStep: .register)
    #expect(viewModel.isRegisterFormValid == false)

    viewModel.username = faker.internet.username()
    viewModel.email = faker.internet.email()
    viewModel.password = faker.internet.password()
    viewModel.confirmPassword = viewModel.password
    #expect(viewModel.isRegisterFormValid == true)
  }

  func testSignInSucceeds() async throws {
    let stubRepository = UserRepositoryStub(expectedSession: mockUserSession)
    DataRepositoryContainer.shared.userRepository.register { stubRepository }
    defer { DataRepositoryContainer.shared.userRepository.reset() }

    let userStoreStub = UserStoreStub()
    let eventExpectation = self.expectation(description: "Should send didLogin event")
    let cancellable = userStoreStub.eventPublisher
      .sink { event in
        guard event == .didLogin else {
          XCTFail("Invalid event")
          return
        }
        eventExpectation.fulfill()
      }
    Container.shared.userStore.register { userStoreStub }
    defer { Container.shared.userStore.reset() }

    let viewModel = AuthenticationViewModel(initialStep: .login)
    viewModel.email = faker.internet.email()
    viewModel.password = faker.internet.password()
    viewModel.signIn()

    await fulfillment(of: [eventExpectation], timeout: 1)
  }

  func testSignInFailureShowsToast() async throws {
    let showToastExpectation = self.expectation(description: "should show toast")
    let mockToastManager = MockToastManager()
    mockToastManager.showExpectation = showToastExpectation
    Container.shared.toastManager.register { mockToastManager }
    defer { Container.shared.toastManager.reset() }

    Container.shared.userStore.register { UserStoreStub() }
    defer { Container.shared.userStore.reset() }

    let viewModel = AuthenticationViewModel(initialStep: .login)
    viewModel.email = faker.internet.email()
    viewModel.password = faker.internet.password()
    viewModel.signIn()

    await fulfillment(of: [showToastExpectation], timeout: 1)
  }

  func testSignUpSucceeds() async throws {
    let stubRepository = UserRepositoryStub(expectedSession: mockUserSession)
    DataRepositoryContainer.shared.userRepository.register { stubRepository }
    defer { DataRepositoryContainer.shared.userRepository.reset() }

    let userStoreStub = UserStoreStub()
    let eventExpectation = self.expectation(description: "Should send didLogin event")
    let cancellable = userStoreStub.eventPublisher
      .sink { event in
        guard event == .didLogin else {
          XCTFail("Invalid event")
          return
        }
        eventExpectation.fulfill()
      }
    Container.shared.userStore.register { userStoreStub }
    defer { Container.shared.userStore.reset() }

    let viewModel = AuthenticationViewModel(initialStep: .register)
    viewModel.username = faker.internet.username()
    viewModel.email = faker.internet.email()
    viewModel.password = faker.internet.password()
    viewModel.confirmPassword = viewModel.password
    viewModel.signUp()

    await fulfillment(of: [eventExpectation], timeout: 1)
  }

  func testSignUpFailureShowsToast() async throws {
    let showToastExpectation = self.expectation(description: "should show toast")
    let mockToastManager = MockToastManager()
    mockToastManager.showExpectation = showToastExpectation
    Container.shared.toastManager.register { mockToastManager }
    defer { Container.shared.toastManager.reset() }

    Container.shared.userStore.register { UserStoreStub() }
    defer { Container.shared.userStore.reset() }

    let viewModel = AuthenticationViewModel(initialStep: .register)
    viewModel.username = faker.internet.username()
    viewModel.email = faker.internet.email()
    viewModel.password = faker.internet.password()
    viewModel.confirmPassword = viewModel.password
    viewModel.signUp()

    await fulfillment(of: [showToastExpectation], timeout: 1)
  }
}

extension AuthenticationViewModelTests {
  private var mockUserSession: UserSession {
    UserSession(token: .init(value: "token"), user: .init(id: UUID()))
  }
}
