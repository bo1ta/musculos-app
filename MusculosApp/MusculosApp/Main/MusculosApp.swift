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
  @State private var appModel = AppModel()

  var body: some Scene {
    WindowGroup {
      Group {
        switch appModel.appState {
        case .loggedIn:
          RootTabView()

        case .loggedOut:
          SplashScreen()
            .transition(.asymmetric(insertion: .opacity, removal: .push(from: .top)))

        case .onboarding:
          OnboardingScreen()
            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .scale))

        case .loading:
          LoadingOverlayView(progress: $appModel.progress)
            .transition(.asymmetric(insertion: .opacity, removal: .push(from: .top)))
        }
      }
      .animation(.smooth(duration: UIConstant.AnimationDuration.medium), value: appModel.appState)
      .toastView(toast: $appModel.toast)
      .task {
        await appModel.initialLoad()
      }
      .onChange(of: scenePhase) { _, newPhase in
        appModel.didChangeScenePhase(newPhase)
      }
    }
  }
}
