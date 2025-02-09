//
//  UserStore.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 01.01.2025.
//

import Combine
import DataRepository
import Factory
import Foundation
import Models
import NetworkClient
import Storage
import Utility

// MARK: - UserStoreEvent

public enum UserStoreEvent: Equatable {
  case didFinishOnboarding
  case didLogin
  case didLogout
  case didUpdateUser(UserProfile)

  public static func ==(_ lhs: UserStoreEvent, rhs: UserStoreEvent) -> Bool {
    switch (lhs, rhs) {
    case (.didFinishOnboarding, .didFinishOnboarding):
      return true
    case (.didLogin, .didLogin):
      return true
    case (.didLogout, .didLogout):
      return true
    case (.didUpdateUser(let lhsUser), .didUpdateUser(let rhsUser)):
      return lhsUser == rhsUser
    default:
      return false
    }
  }
}

// MARK: - UserStoreProtocol

public protocol UserStoreProtocol: Sendable {
  var eventPublisher: AnyPublisher<UserStoreEvent, Never> { get }
  var currentUser: UserProfile? { get }

  func refreshUser() async -> UserProfile?
  func authenticateSession(_ session: UserSession) async
  func updateOnboardingStatus(_ onboardingData: OnboardingData) async
  func startObservingUser()
  func stopObservingUser()
  func logOut()
}

// MARK: - UserStore

public final class UserStore: @unchecked Sendable, UserStoreProtocol {

  // MARK: Dependencies

  @LazyInjected(\NetworkContainer.userManager) private var userManager: UserSessionManagerProtocol
  @LazyInjected(\DataRepositoryContainer.userRepository) private var repository: UserRepositoryProtocol

  // MARK: Private properties

  private var currentUserListener: EntityPublisher<UserProfileEntity>?
  private var userListenerCancellable: AnyCancellable?
  private var logoutNotificationCancellable: AnyCancellable?
  private let eventSubject = PassthroughSubject<UserStoreEvent, Never>()

  // MARK: Public

  @Atomic public var currentUser: UserProfile?

  public var eventPublisher: AnyPublisher<UserStoreEvent, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  init() {
    logoutNotificationCancellable = NotificationCenter.default.publisher(for: .authTokenDidFail)
      .throttle(for: 1, scheduler: RunLoop.main, latest: false)
      .sink { [weak self] _ in
        self?.logOut()
      }
  }

  @discardableResult
  public func refreshUser() async -> UserProfile? {
    guard let currentUser = try? await repository.getCurrentUser() else {
      return nil
    }

    self.currentUser = currentUser
    return currentUser
  }

  public func authenticateSession(_ session: UserSession) async {
    userManager.updateSession(session)

    if let user = await repository.getUserByID(session.userID) {
      currentUser = user
      sendEvent(.didLogin)
    }
  }

  public func updateOnboardingStatus(_ onboardingData: OnboardingData) async {
    do {
      try await repository.updateProfileUsingOnboardingData(onboardingData)
      sendEvent(.didFinishOnboarding)
    } catch {
      Logger.error(error, message: "Could not update profile with onboarding data")
    }
  }

  public func logOut() {
    currentUser = nil
    stopObservingUser()
    userManager.clearSession()
    StorageContainer.shared.storageManager().reset()
    DataRepositoryContainer.shared.reset()
    sendEvent(.didLogout)
  }

  private func sendEvent(_ event: UserStoreEvent) {
    eventSubject.send(event)
  }
}

// MARK: CurrentUser Observing

extension UserStore {
  public func startObservingUser() {
    guard let userID = currentUser?.id else {
      Logger.error(MusculosError.unexpectedNil, message: "Cannot observe user, current user is nil!")
      return
    }

    let isAlreadyObserving = userListenerCancellable != nil && currentUserListener != nil
    guard !isAlreadyObserving else {
      Logger.warning(message: "Already observing current user")
      return
    }

    let userEntityListener = repository.entityPublisherForUserID(userID)
    userListenerCancellable = userEntityListener.publisher
      .sink { [weak self] updatedUser in
        self?.currentUser = updatedUser
        self?.sendEvent(.didUpdateUser(updatedUser))
      }

    currentUserListener = userEntityListener
  }

  public func stopObservingUser() {
    userListenerCancellable?.cancel()
    userListenerCancellable = nil
    currentUserListener = nil
  }
}
