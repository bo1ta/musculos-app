//
//  UserStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import Foundation
import SwiftUI
import Factory
import Combine
import Models
import Storage
import Utility
import NetworkClient
import DataRepository

@Observable
@MainActor
final class UserStore {

  // MARK: - Injected Dependencies

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.userRepository) private var userRepository: UserRepository

  @ObservationIgnored
  @Injected(\StorageContainer.userManager) private var userManager: UserSessionManagerProtocol

  @ObservationIgnored
  @Injected(\.taskManager) private var taskManager: TaskManagerProtocol

  // MARK: - Event

  enum Event {
    case didLogin
    case didLogOut
    case didFinishOnboarding
  }

  // MARK: - Private

  private let eventSubject = PassthroughSubject<Event, Never>()

  private(set) var currentUserProfile: UserProfile?
  private(set) var currentUserState: UserSessionState = .unauthenticated
  private(set) var isLoading: Bool = false

  var eventPublisher: AnyPublisher<Event, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  var displayName: String {
    return currentUserProfile?.username ?? ""
  }

  var isOnboarded: Bool {
    return currentUserProfile?.isOnboarded ?? false
  }

  var isLoggedIn: Bool {
    return userManager.isAuthenticated && currentUserProfile != nil
  }

  func initialLoad() async {
    currentUserState = userManager.currentState()

    switch currentUserState {
    case .authenticated(let userSession):
      handlePostLogin(session: userSession)
    case .unauthenticated:
      MusculosLogger.logInfo(message: "Could not find user. Using logged-out state ", category: .coreData)
    }
  }

  func refreshUser() {
    let task = Task {
      do {
        try await loadCurrentUser()
      } catch {
        MusculosLogger.logError(error, message: "Could not refresh user", category: .coreData)
      }
    }

    taskManager.addTask(task)
  }

  func handlePostLogin(session: UserSession) {
    updateSession(session)

    let task = Task { [weak self] in
      guard let self else { return }

      isLoading = true
      defer { isLoading = false }

      do {
        try await loadCurrentUser()
        sendEvent(.didLogin)
      } catch {
        MusculosLogger.logError(error, message: "Error loading current user", category: .coreData)
      }
    }

    taskManager.addTask(task)
  }

  func updateIsOnboarded(_ isOnboarded: Bool) {
    let task = Task { [weak self] in
      do {
        try await self?.userRepository.updateProfile(isOnboarded: isOnboarded)
        self?.sendEvent(.didFinishOnboarding)
      } catch {
        MusculosLogger.logError(error, message: "Could not update isOnboarded field.", category: .coreData)
      }
    }
    taskManager.addTask(task)
  }

  /// Listens to a stream that first returns the local user, and then the api user
  ///
  private func loadCurrentUser() async throws {
    currentUserProfile = await userRepository.currentUser()
  }

  private func sendEvent(_ event: Event) {
    eventSubject.send(event)
  }

  private func cleanUp() {
    taskManager.cancelAllTasks()
  }

  private func updateSession(_ session: UserSession) {
    userManager.updateSession(session)
  }
}
