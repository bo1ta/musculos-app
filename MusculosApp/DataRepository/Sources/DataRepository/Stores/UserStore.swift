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
  var eventPublisher: AnyPublisher<UserStoreEvent, Never> { get }

  @discardableResult
  func loadCurrentUser() async -> UserProfile?
  func updateOnboardingStatus(_ onboardingData: OnboardingData) async
}

// MARK: - UserStore

public final class UserStore: @unchecked Sendable, UserStoreProtocol {
  @LazyInjected(\DataRepositoryContainer.userRepository) private var repository: UserRepositoryProtocol

  private let eventSubject = PassthroughSubject<UserStoreEvent, Never>()

  public var eventPublisher: AnyPublisher<UserStoreEvent, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  @discardableResult
  public func loadCurrentUser() async -> UserProfile? {
    guard let currentUser = try? await repository.getCurrentUser() else {
      return nil
    }
    registerCurrentUser(currentUser)
    return currentUser
  }

  private func registerCurrentUser(_ user: UserProfile) {
    Container.shared.currentUser.register { user }
  }

  public func updateOnboardingStatus(_ onboardingData: OnboardingData) async {
    do {
      try await repository.updateProfileUsingOnboardingData(onboardingData)
      eventSubject.send(.didFinishOnboarding)
    } catch {
      Logger.error(error, message: "Could not update profile with onboarding data")
    }
  }
}
