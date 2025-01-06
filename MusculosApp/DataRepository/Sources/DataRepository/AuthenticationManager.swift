//
//  AuthenticationManager.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 06.01.2025.
//

import Combine
import Factory
import Foundation
import Models
import NetworkClient
import Storage
import Utility

// MARK: - AuthenticationEvent

public enum AuthenticationEvent {
  case didLogin
  case didLogout
}

// MARK: - AuthenticationManagerProtocol

public protocol AuthenticationManagerProtocol {
  var eventPublisher: AnyPublisher<AuthenticationEvent, Never> { get }

  func authenticateSession(_ session: UserSession)
  func logOut()
}

// MARK: - AuthenticationManager

public class AuthenticationManager: AuthenticationManagerProtocol {
  @Injected(\StorageContainer.storageManager) private var storageManager: StorageManagerType
  @Injected(\NetworkContainer.userManager) private var userManager: UserSessionManagerProtocol

  private let eventSubject = PassthroughSubject<AuthenticationEvent, Never>()
  private var cancellables = Set<AnyCancellable>()

  public var eventPublisher: AnyPublisher<AuthenticationEvent, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  init() {
    NotificationCenter.default.publisher(for: .authTokenDidFail)
      .throttle(for: 1, scheduler: RunLoop.main, latest: false)
      .sink { [weak self] _ in
        self?.logOut()
      }
      .store(in: &cancellables)
  }

  public func authenticateSession(_ session: UserSession) {
    userManager.updateSession(session)
    eventSubject.send(.didLogin)
  }

  public func logOut() {
    storageManager.reset()
    userManager.clearSession()
    DataRepositoryContainer.shared.reset()
    sendEvent(.didLogout)
  }

  private func sendEvent(_ event: AuthenticationEvent) {
    eventSubject.send(event)
  }
}
