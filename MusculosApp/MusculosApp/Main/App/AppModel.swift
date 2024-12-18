//
//  AppModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Factory
import Components
import Observation
import Network
import NetworkClient
import Utility

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

  let userStore: UserStore

  init(userStore: UserStore = UserStore()) {
    self.userStore = userStore
  }

  func handleConnectionStatusUpdate(_ connectionStatus: NWPath.Status) {
    switch connectionStatus {
    case .satisfied:
      guard var toast, toast.style == .warning else {
        return
      }
      toast = Toast(style: .success, message: "Connected")
      break
    case .unsatisfied:
      toast = Toast(style: .warning, message: "Lost internet connection. Trying to reconnect...")
      break
    case .requiresConnection:
      break
    @unknown default:
      break
    }
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
        networkMonitor.startMonitoring()
      }
    } else {
      appState = .loggedOut
    }
  }

  func handleUserEvent(_ event: UserStore.Event) {
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
