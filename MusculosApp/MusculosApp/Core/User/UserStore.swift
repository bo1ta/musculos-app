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

@Observable
@MainActor
final class UserStore {

  // MARK: - Injected Dependencies

  @ObservationIgnored
  @Injected(\.userDataStore) private var dataStore: UserDataStoreProtocol

  @ObservationIgnored
  @Injected(\.userManager) private var userManager: UserManagerProtocol

  @ObservationIgnored
  @Injected(\.taskManager) private var taskManager: TaskManagerProtocol

  // MARK: - Event

  enum Event {
    case didLogin
    case didLogOut
    case didFinishOnboarding
  }

  // MARK: - Private

  private let _event = PassthroughSubject<Event, Never>()
  private(set) var currentUserProfile: UserProfile?
  private(set) var userSession: UserSession?
  private(set) var isLoading: Bool = false

  // MARK: - Public

  var event: AnyPublisher<Event, Never> {
    _event.eraseToAnyPublisher()
  }

  var displayName: String {
    return currentUserProfile?.username ?? "user"
  }
  
  var isOnboarded: Bool {
    return userSession?.isOnboarded ?? false
  }
  
  var isLoggedIn: Bool {
    return userSession != nil && currentUserProfile != nil
  }

  func initialLoad() async {
    guard let userSession = userManager.currentSession() else { return }

    self.userSession = userSession

    if let currentProfile = await dataStore.loadProfileByEmail(userSession.email) {
      self.currentUserProfile = currentProfile
    }
  }
  
  func refreshSession() {
    if let session = userManager.currentSession() {
      userSession = session
    }
  }

  func refreshUser() {
    guard let userSession else { return }

    let task = Task {
      currentUserProfile = await dataStore.loadProfile(userId: userSession.userId)
    }
    taskManager.addTask(task)
  }

  func updateIsOnboarded(_ isOnboarded: Bool) {
    guard var userSession else { return }

    userSession.isOnboarded  = isOnboarded
    updateSession(userSession)

    _event.send(.didFinishOnboarding)
  }

  func handlePostRegister(session: UserSession) {
    updateSession(session)

    let task = Task {
      isLoading = true
      defer { isLoading = false }

      await createUser(from: session)
    }

    taskManager.addTask(task)
  }

  func handlePostLogin(session: UserSession) {
    updateSession(session)

    let task = Task { [weak self] in
      guard let self else { return }

      isLoading = true
      defer { isLoading = false }

      if let profile = await dataStore.loadProfileByEmail(session.email) {
        currentUserProfile = profile
        _event.send(.didLogin)
      } else {
        await createUser(from: session)
      }
    }

    taskManager.addTask(task)
  }

  // MARK: - Private helpers

  private func createUser(from session: UserSession) async {
    let profile = UserProfile(
      userId: session.userId,
      email: session.email,
      username: session.username
    )

    do {
      try await dataStore.createUser(profile: profile)
      currentUserProfile = profile
      _event.send(.didLogin)
    } catch {
      MusculosLogger.logError(error, message: "Cannot create user", category: .coreData)
    }
  }

  private func updateSession(_ session: UserSession) {
    userSession = session
    userManager.updateSession(session)
  }
}
