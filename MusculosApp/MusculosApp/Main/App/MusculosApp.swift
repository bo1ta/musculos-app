//
//  MusculosAppApp.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import Components
import Utility
import Factory
import NetworkClient
import Network

struct MusculosApp: App {
  @State private var appModel = AppModel()

  var body: some Scene {
    WindowGroup {
        Group {
          switch appModel.appState {
          case .loggedIn:
            RootTabView()
          case .loggedOut:
            SplashScreen()
              .transition(.asymmetric(insertion: .opacity, removal: .identity))
          case .onboarding:
            OnboardingScreen()
              .transition(.asymmetric(insertion: .push(from: .bottom), removal: .scale))
          case .loading:
            LoadingOverlayView(progress: $appModel.progress)
          }
        }
        .animation(.smooth(duration: UIConstant.mediumAnimationDuration), value: appModel.appState)
        .toastView(toast: $appModel.toast)
        .onReceive(appModel.userStore.eventPublisher, perform: appModel.handleUserEvent(_:))
        .onReceive(appModel.networkMonitor.connectionStatusPublisher, perform: appModel.handleConnectionStatusUpdate(_:))
        .task {
          await appModel.loadInitialState()
        }
        .environment(\.userStore, appModel.userStore)
        .environment(\.healthKitViewModel, HealthKitViewModel())
    }
  }
}
