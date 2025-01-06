//
//  AuthenticationManagerStub.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 06.01.2025.
//

import Combine
import Models

public class AuthenticationManagerStub: AuthenticationManagerProtocol, @unchecked Sendable {
  public var eventPublisher: AnyPublisher<AuthenticationEvent, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  private let eventSubject = PassthroughSubject<AuthenticationEvent, Never>()

  public func authenticateSession(_: UserSession) {
    eventSubject.send(.didLogin)
  }

  public func logOut() {
    eventSubject.send(.didLogout)
  }
}
