//
//  UserStore.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 01.01.2025.
//

import Combine
import Factory
import Foundation
import Models
import Storage
import Utility

// MARK: - UserStoreEvent

public enum UserStoreEvent {
  case didLogin
  case didLogout
  case didFinishOnboarding
}

// MARK: - UserStoreProtocol

public protocol UserStoreProtocol {
  var currentUser: UserProfile? { get set }
  var eventPublisher: AnyPublisher<UserStoreEvent, Never> { get }
  func loadCurrentUser() async -> UserProfile?
  func authenticateSession(_ session: UserSession) async
  func updateOnboardingStatus(_ onboardingData: OnboardingData) async
}

extension UserStoreProtocol {
  public var isOnboarded: Bool {
    currentUser?.isOnboarded ?? false
  }

  public var isLoggedIn: Bool {
    currentUser != nil
  }
}

// MARK: - UserStore

public final class UserStore: @unchecked Sendable, UserStoreProtocol {

  // MARK: Private

  @Injected(\DataRepositoryContainer.userRepository) private var userRepository: UserRepositoryProtocol
  @Injected(\StorageContainer.userManager) private var userManager: UserSessionManagerProtocol

  private var cancellables = Set<AnyCancellable>()
  private let eventSubject = PassthroughSubject<UserStoreEvent, Never>()

  // MARK: Public

  @Atomic public var currentUser: UserProfile?

  public var eventPublisher: AnyPublisher<UserStoreEvent, Never> {
    eventSubject
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  init() {
    NotificationCenter.default.publisher(for: .authTokenDidFail)
      .throttle(for: 1, scheduler: RunLoop.main, latest: false)
      .sink { [weak self] _ in
        self?.logOut()
      }
      .store(in: &cancellables)
  }

  private func logOut() {
    StorageContainer.shared.storageManager().reset()
    userManager.clearSession()
    currentUser = nil
    sendEvent(.didLogout)
  }

  @discardableResult
  public func loadCurrentUser() async -> UserProfile? {
    guard let currentUser = try? await userRepository.getCurrentUser() else {
      return nil
    }

    self.currentUser = currentUser
    return currentUser
  }

  public func authenticateSession(_ session: UserSession) async {
    userManager.updateSession(session)

    do {
      currentUser = try await userRepository.getCurrentUser()
      sendEvent(.didLogin)
    } catch {
      Logger.error(error, message: "Error authenticating session")
    }
  }

  public func updateOnboardingStatus(_ onboardingData: OnboardingData) async {
    do {
      try await userRepository.updateProfileUsingOnboardingData(onboardingData)
      sendEvent(.didFinishOnboarding)
    } catch {
      Logger.error(error, message: "Could not update profile with onboarding data")
    }
  }

  private func sendEvent(_ event: UserStoreEvent) {
    eventSubject.send(event)
  }
}
