//
//  AppState.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Combine
import Components
import DataRepository
import Factory
import Models
import Network
import NetworkClient
import SwiftUI

// MARK: - AppState

@Observable
@MainActor
final class AppState {

  // MARK: State

  enum State {
    case loggedIn
    case loggedOut
    case onboarding
    case loading
  }

  // MARK: Dependencies

  @ObservationIgnored
  @Injected(\NetworkContainer.networkMonitor) private var networkMonitor: NetworkMonitorProtocol

  @ObservationIgnored
  @Injected(\.userStore) private var userStore: UserStoreProtocol

  @ObservationIgnored
  @Injected(\.toastManager) private var toastManager: ToastManagerProtocol

  private var cancellables = Set<AnyCancellable>()
  private(set) var state = State.loading

  var progress = 0.0
  var toast: Toast?

  init() {
    setupObservers()
  }

  private func setupObservers() {
    networkMonitor.connectionStatusPublisher
      .sink { [weak self] connectionStatus in
        self?.didChangeConnectionStatus(connectionStatus)
      }
      .store(in: &cancellables)

    userStore.eventPublisher
      .sink { [weak self] event in
        self?.didReceiveUserStoreEvent(event)
      }
      .store(in: &cancellables)

    toastManager.toastPublisher
      .sink { [weak self] toast in
        self?.toast = toast
      }
      .store(in: &cancellables)
  }

  func initialLoad() async {
    progress = 0.3
    defer { progress = 1.0 }

    await determineUserState()
  }

  private func determineUserState() async {
    guard let currentUser = await userStore.refreshUser() else {
      state = .loggedOut
      return
    }

    userStore.startObservingUser()
    state = currentUser.isOnboarded ? .loggedIn : .onboarding
  }
}

// MARK: - Observers handling

extension AppState {
  func didChangeScenePhase(_ phase: ScenePhase) {
    switch phase {
    case .active:
      networkMonitor.startMonitoring()
    case .background:
      networkMonitor.stopMonitoring()
    default:
      break
    }
  }

  private func didChangeConnectionStatus(_ connectionStatus: NWPath.Status) {
    switch connectionStatus {
    case .satisfied:
      guard toast?.style == .warning else {
        return
      }
      toastManager.showSuccess("Connected to the internet!")

    case .unsatisfied:
      toastManager.showWarning("Logged out")

    default:
      break
    }
  }

  private func didReceiveUserStoreEvent(_ event: UserStoreEvent) {
    switch event {
    case .didLogin:
      Task {
        await determineUserState()
      }

    case .didFinishOnboarding:
      state = .loggedIn

    case .didLogout:
      state = .loggedOut
      toastManager.showInfo("Logged out")

    default:
      break
    }
  }
}
