//
//  UserStoreStub.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Combine
import Foundation
import Models
import Utility

@testable import MusculosApp

public class UserStoreStub: UserStoreProtocol, @unchecked Sendable {
  public var currentUser: Models.UserProfile?

  public var expectedLoadResult: UserProfile?
  private let eventSubject = PassthroughSubject<UserStoreEvent, Never>()

  public var eventPublisher: AnyPublisher<UserStoreEvent, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  public func refreshUser() async -> UserProfile? {
    expectedLoadResult
  }

  public func logOut() {
    eventSubject.send(.didLogout)
  }

  public func authenticateSession(_: UserSession) {
    eventSubject.send(.didLogin)
  }

  public func updateOnboardingStatus(_: Models.OnboardingData) async {
    eventSubject.send(.didFinishOnboarding)
  }

  public func startObservingUser() { }

  public func stopObservingUser() { }
}
