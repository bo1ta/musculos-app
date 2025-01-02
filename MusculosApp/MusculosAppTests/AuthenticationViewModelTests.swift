//
//  AuthenticationViewModelTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Foundation
import Testing
import Combine
import Factory
import XCTest
import Models
import Fakery

@testable import MusculosApp
@testable import DataRepository
@testable import Components

@MainActor
class AuthenticationViewModelTests: XCTestCase {
  private let faker = Faker()
  private let cancellables: Set<AnyCancellable> = []

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

    let userStore = UserStore()
    let eventExpectation = self.expectation(description: "should emit didLogin event")
    let cancellable = userStore.eventPublisher
      .sink { event in
        guard event == .didLogin else {
          XCTFail("Invalid event")
          return
        }
        eventExpectation.fulfill()
      }
    defer { cancellable.cancel() }

    DataRepositoryContainer.shared.userStore.register { userStore }
    defer { DataRepositoryContainer.shared.userStore.reset() }

    let viewModel = AuthenticationViewModel(initialStep: .login)
    viewModel.email = faker.internet.email()
    viewModel.password = faker.internet.password()
    viewModel.signIn()

    await viewModel.authTask?.value
    await fulfillment(of: [eventExpectation])
  }

  func testSignInFailureShowsToast() async throws {
    let showToastExpectation = self.expectation(description: "should show toast")
    let mockToastManager = MockToastManager()
    mockToastManager.showExpectation = showToastExpectation
    Container.shared.toastManager.register { mockToastManager }
    defer { Container.shared.toastManager.reset() }

    DataRepositoryContainer.shared.userRepository.register { UserRepositoryStub()
    }
    defer { DataRepositoryContainer.shared.reset() }

    let viewModel = AuthenticationViewModel(initialStep: .login)
    viewModel.email = faker.internet.email()
    viewModel.password = faker.internet.password()
    viewModel.signIn()

    await viewModel.authTask?.value
    await fulfillment(of: [showToastExpectation])
  }

  func testSignUpSucceeds() async throws {
    let stubRepository = UserRepositoryStub(expectedSession: mockUserSession)
    DataRepositoryContainer.shared.userRepository.register { stubRepository }
    defer { DataRepositoryContainer.shared.userRepository.reset() }

    let userStore = UserStore()
    let eventExpectation = self.expectation(description: "should emit didLogin event")
    let cancellable = userStore.eventPublisher
      .sink { event in
        guard event == .didLogin else {
          XCTFail("Invalid event")
          return
        }
        eventExpectation.fulfill()
      }
    defer { cancellable.cancel() }

    DataRepositoryContainer.shared.userStore.register { userStore }
    defer { DataRepositoryContainer.shared.userStore.reset() }

    let viewModel = AuthenticationViewModel(initialStep: .register)
    viewModel.username = faker.internet.username()
    viewModel.email = faker.internet.email()
    viewModel.password = faker.internet.password()
    viewModel.confirmPassword = viewModel.password
    viewModel.signUp()

    await viewModel.authTask?.value
    await fulfillment(of: [eventExpectation])
  }

  func testSignUpFailureShowsToast() async throws {
    let showToastExpectation = self.expectation(description: "should show toast")
    let mockToastManager = MockToastManager()
    mockToastManager.showExpectation = showToastExpectation
    Container.shared.toastManager.register { mockToastManager }
    defer { Container.shared.toastManager.reset() }

    DataRepositoryContainer.shared.userRepository.register { UserRepositoryStub()
    }
    defer { DataRepositoryContainer.shared.reset() }

    let viewModel = AuthenticationViewModel(initialStep: .register)
    viewModel.username = faker.internet.username()
    viewModel.email = faker.internet.email()
    viewModel.password = faker.internet.password()
    viewModel.confirmPassword = viewModel.password
    viewModel.signUp()

    await viewModel.authTask?.value
    await fulfillment(of: [showToastExpectation])
  }
}

extension AuthenticationViewModelTests {
  private var mockUserSession: UserSession {
    UserSession(token: .init(value: "token"), user: .init(id: UUID()))
  }

  private class MockToastManager: ToastManagerProtocol {
    var showExpectation: XCTestExpectation?

    var toastPublisher: AnyPublisher<Toast?, Never> {
      return toastSubject.eraseToAnyPublisher()
    }

    private let toastSubject = CurrentValueSubject<Toast?, Never>(nil)

    func show(_ toast: Components.Toast, autoDismissAfter seconds: TimeInterval) {
      showExpectation?.fulfill()
    }
  }
}
