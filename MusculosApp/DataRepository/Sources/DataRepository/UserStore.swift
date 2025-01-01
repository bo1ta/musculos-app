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

// MARK: - UserStore

public final class UserStore: @unchecked Sendable {

  // MARK: Private

  @Injected(\DataRepositoryContainer.userRepository) private var userRepository: UserRepository
  @Injected(\StorageContainer.userManager) private var userManager: UserSessionManagerProtocol

  private var cancellables = Set<AnyCancellable>()
  private let eventSubject = PassthroughSubject<Event, Never>()

  // MARK: Public

  @Atomic public private(set) var currentUser: UserProfile?

  public var eventPublisher: AnyPublisher<Event, Never> {
    eventSubject
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  public var isOnboarded: Bool {
    currentUser?.isOnboarded ?? false
  }

  public var isLoggedIn: Bool {
    currentUser != nil
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
    guard let currentUser = await userRepository.getCurrentUser() else {
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

  private func sendEvent(_ event: Event) {
    eventSubject.send(event)
  }
}

// MARK: UserStore.Event

extension UserStore {
  public enum Event {
    case didLogin
    case didLogout
    case didFinishOnboarding
  }
}
