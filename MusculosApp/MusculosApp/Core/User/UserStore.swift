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

  private let eventSubject = PassthroughSubject<Event, Never>()

  var eventPublisher: AnyPublisher<Event, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  // MARK: - Observed properties

  private(set) var currentUserProfile: UserProfile?
  private(set) var currentUserState: UserSessionState = .unauthenticated
  private(set) var isLoading = false
  private var cancellables = Set<AnyCancellable>()

  var displayName: String {
    return currentUserProfile?.username ?? ""
  }

  var isOnboarded: Bool {
    return currentUserProfile?.isOnboarded ?? false
  }

  var isLoggedIn: Bool {
    return userManager.isAuthenticated && currentUserProfile != nil
  }

  init() {
    NotificationCenter.default.publisher(for: .authTokenDidFail)
      .debounce(for: .seconds(1), scheduler: RunLoop.main)
      .sink { [weak self] _ in
        self?.logOut()
      }
      .store(in: &cancellables)
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

  func handlePostOnboarding(_ onboardingData: OnboardingData) {
    let task = Task { [weak self] in
      do {
        try await self?.userRepository.updateProfileUsingOnboardingData(onboardingData)
        self?.sendEvent(.didFinishOnboarding)
      } catch {
        MusculosLogger.logError(error, message: "Could not update profile with onboarding data", category: .dataRepository)
      }
    }
    taskManager.addTask(task)
  }

  private func loadCurrentUser() async throws {
    currentUserProfile = await userRepository.getCurrentUser()
  }

  private func logOut() {
    userManager.clearSession()
    eventSubject.send(.didLogOut)
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
