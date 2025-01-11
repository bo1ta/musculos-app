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

public class CurrentUserHandlerStub: UserHandling, @unchecked Sendable {
  public var expectedLoadResult: UserProfile?
  private let eventSubject = PassthroughSubject<UserStoreEvent, Never>()

  public var eventPublisher: AnyPublisher<UserStoreEvent, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  public func loadUser() async -> UserProfile? {
    expectedLoadResult
  }

  public func updateOnboardingStatus(_: Models.OnboardingData) async {
    eventSubject.send(.didFinishOnboarding)
  }
}
