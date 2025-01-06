//
//  AppModel.swift
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

enum AppState {
  case loggedIn
  case loggedOut
  case onboarding
  case loading
}

// MARK: - AppModel

@Observable
@MainActor
final class AppModel {

  @ObservationIgnored
  @Injected(\NetworkContainer.networkMonitor) private var networkMonitor: NetworkMonitorProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.authenticationManager) private var authenticationManager: AuthenticationManagerProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.userStore) private var userStore: UserStoreProtocol

  @ObservationIgnored
  @Injected(\.toastManager) private var toastManager: ToastManagerProtocol

  private var cancellables = Set<AnyCancellable>()
  private(set) var appState = AppState.loading

  var progress = 0.0
  var toast: Toast?

  init() {
    setupObservers()
  }

  func initialLoad() async {
    progress = 0.3

    await userStore.loadCurrentUser()

    progress = 1.0

    if userStore.isLoggedIn {
      if !userStore.isOnboarded {
        appState = .onboarding
      } else {
        appState = .loggedIn
      }
    } else {
      appState = .loggedOut
    }
  }

  private func setupObservers() {
    networkMonitor.connectionStatusPublisher
      .sink { [weak self] connectionStatus in
        self?.didChangeConnectionStatus(connectionStatus)
      }
      .store(in: &cancellables)

    authenticationManager.eventPublisher
      .sink { [weak self] event in
        self?.didReceiveAuthenticationEvent(event)
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
}

// MARK: - Observers handling

extension AppModel {
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

  private func didReceiveAuthenticationEvent(_ event: AuthenticationEvent) {
    switch event {
    case .didLogin:
      appState = userStore.isOnboarded ? .loggedIn : .onboarding

    case .didLogout:
      appState = .loggedOut
      toastManager.showInfo("Logged out")
    }
  }

  private func didReceiveUserStoreEvent(_ event: UserStoreEvent) {
    switch event {
    case .didFinishOnboarding:
      appState = .loggedIn
    }
  }
}
