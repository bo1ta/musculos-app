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

@Observable
@MainActor
final class UserStore {

  // MARK: - Injected Dependencies

  @ObservationIgnored
  @Injected(\NetworkContainer.userService) private var userService

  @ObservationIgnored
  @Injected(\StorageContainer.dataController) private var dataController

  @ObservationIgnored
  @Injected(\StorageContainer.userManager) private var userManager

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

  // MARK: - Public

  var eventPublisher: AnyPublisher<Event, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  var displayName: String {
    return currentUserProfile?.username ?? ""
  }
  
  var isOnboarded: Bool {
    return currentUserProfile?.isOnboarded ?? true
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

  private func loadUserFromLocalStorage() async {
    currentUserProfile = await dataController.getCurrentUserProfile()
  }

  func refreshUser() {
    let task = Task {
      await loadUserFromServer()
    }
    taskManager.addTask(task)
  }

  func updateIsOnboarded(_ isOnboarded: Bool) {
    let task = Task { [weak self] in
      do {
        try await self?.dataController.updateUserProfile(isOnboarded: isOnboarded)
        self?.sendEvent(.didFinishOnboarding)
      } catch {
        MusculosLogger.logError(error, message: "Could not update isOnboarded field.", category: .coreData)
      }
    }
    taskManager.addTask(task)
  }

  func handlePostRegister(session: UserSession) {
    updateSession(session)
    handlePostLogin(session: session)
  }

  func handlePostLogin(session: UserSession) {
    updateSession(session)

    let task = Task { [weak self] in
      guard let self else { return }

      isLoading = true
      defer { isLoading = false }

      if let profile = await dataController.getCurrentUserProfile() {
        currentUserProfile = profile
        sendEvent(.didLogin)
      } else {
        await loadUserFromServer()
      }
    }

    taskManager.addTask(task)
  }

  private func loadUserFromServer() async {
    do {
      currentUserProfile = try await userService.currentUser()
      sendEvent(.didLogin)
    } catch {
      MusculosLogger.logError(error, message: "Initial load failed", category: .networking)
    }
  }

  private func sendEvent(_ event: Event) {
    eventSubject.send(event)
  }

  private func updateSession(_ session: UserSession) {
    userManager.updateSession(session)
  }
}
