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
import NetworkClient
import Storage
import Utility

// MARK: - UserStoreEvent

public enum UserStoreEvent {
  case didFinishOnboarding
}

// MARK: - UserStoreProtocol

public protocol UserStoreProtocol: Sendable {
  var currentUser: UserProfile? { get }
  var eventPublisher: AnyPublisher<UserStoreEvent, Never> { get }

  @discardableResult
  func loadCurrentUser() async -> UserProfile?
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
  @LazyInjected(\DataRepositoryContainer.userRepository) private var userRepository: UserRepositoryProtocol
  @Atomic public private(set) var currentUser: UserProfile?

  private let eventSubject = PassthroughSubject<UserStoreEvent, Never>()

  public var eventPublisher: AnyPublisher<UserStoreEvent, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  @discardableResult
  public func loadCurrentUser() async -> UserProfile? {
    guard let currentUser = try? await userRepository.getCurrentUser() else {
      return nil
    }

    self.currentUser = currentUser
    return currentUser
  }

  public func updateOnboardingStatus(_ onboardingData: OnboardingData) async {
    do {
      try await userRepository.updateProfileUsingOnboardingData(onboardingData)
      currentUser = try await userRepository.getCurrentUser()
      eventSubject.send(.didFinishOnboarding)
    } catch {
      Logger.error(error, message: "Could not update profile with onboarding data")
    }
  }
}
