//
//  MusculosApp.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import Components
import SwiftUI
import Utility

struct MusculosApp: App {
  @Environment(\.scenePhase) private var scenePhase
  @State private var appState = AppState()

  var body: some Scene {
    WindowGroup {
      Group {
        switch appState.state {
        case .loggedIn:
          RootTabView()

        case .loggedOut:
          SplashScreen()
            .transition(.asymmetric(insertion: .opacity, removal: .push(from: .top)))

        case .onboarding:
          OnboardingScreen()
            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .scale))

        case .loading:
          LoadingOverlayView(progress: $appState.progress)
            .transition(.asymmetric(insertion: .opacity, removal: .push(from: .top)))
        }
      }
      .animation(.smooth(duration: UIConstant.AnimationDuration.medium), value: appState.state)
      .toastView(toast: $appState.toast)
      .task {
        await appState.initialLoad()
      }
      .onChange(of: scenePhase) { _, newPhase in
        appState.didChangeScenePhase(newPhase)
      }
    }
  }
}
