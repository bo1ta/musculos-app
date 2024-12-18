//
//  AppModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Factory
import Combine
import Components
import Network
import NetworkClient
import SwiftUI

enum AppState {
  case loggedIn
  case loggedOut
  case onboarding
  case loading
}

@Observable
@MainActor
final class AppModel {
  @ObservationIgnored
  @Injected(\NetworkContainer.networkMonitor) var networkMonitor: NetworkMonitorProtocol

  var progress = 0.0
  var toast: Toast?
  var appState: AppState = .loading

  private var cancellables = Set<AnyCancellable>()
  private var toastTask: Task<Void, Never>?

  let userStore: UserStore

  init(userStore: UserStore = UserStore()) {
    self.userStore = userStore
    setupObservers()
  }

  private func setupObservers() {
    networkMonitor.connectionStatusPublisher
      .sink { [weak self] connectionStatus in
        self?.handleConnectionStatus(connectionStatus)
      }
      .store(in: &cancellables)

    userStore.eventPublisher
      .sink { [weak self] event in
        self?.handleUserEvent(event)
      }
      .store(in: &cancellables)
  }

  func loadInitialState() async {
    progress = 0.1

    await userStore.initialLoad()

    progress = 0.9

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

  func handleScenePhaseChange(_ phase: ScenePhase) {
    switch phase {
    case .active:
      networkMonitor.startMonitoring()
    case .background:
      networkMonitor.stopMonitoring()
    default:
      break
    }
  }

  private func handleConnectionStatus(_ connectionStatus: NWPath.Status) {
    switch connectionStatus {
    case .satisfied:
      guard let toast, toast.style == .warning else {
        return
      }
      showToast(.success, message: "Re-connected to the internet")
    case .unsatisfied:
      showToast(.warning, message: "Lost internet connection. Trying to reconnect...")
    default:
      break
    }
  }

  private func showToast(_ style: Toast.ToastStyle, message: String) {
    toastTask?.cancel()

    toastTask = Task { [weak self] in
      guard let self, !Task.isCancelled else {
        return
      }

      toast = Toast(style: style, message: message)
      try? await Task.sleep(for: .seconds(2))
      toast = nil
    }
  }

  private func handleUserEvent(_ event: UserStore.Event) {
    switch event {
    case .didLogin:
      appState = userStore.isOnboarded ? .loggedIn : .onboarding
    case .didLogOut:
      appState = .loggedOut
    case .didFinishOnboarding:
      appState = .loggedIn
    }
  }
}
