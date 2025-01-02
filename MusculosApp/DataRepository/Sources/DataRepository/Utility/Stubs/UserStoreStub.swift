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

public class UserStoreStub: UserStoreProtocol, @unchecked Sendable {

  public var currentUser: UserProfile?
  public var expectedLoadResult: UserProfile?

  public var eventPublisher: AnyPublisher<UserStoreEvent, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  private let eventSubject = PassthroughSubject<UserStoreEvent, Never>()

  public init(currentUser: Models.UserProfile? = nil) {
    self.currentUser = currentUser
  }

  public func loadCurrentUser() async -> UserProfile? {
    expectedLoadResult
  }

  public func authenticateSession(_: Models.UserSession) async {
    eventSubject.send(.didLogin)
  }

  public func updateOnboardingStatus(_: Models.OnboardingData) async {
    eventSubject.send(.didFinishOnboarding)
  }
}
