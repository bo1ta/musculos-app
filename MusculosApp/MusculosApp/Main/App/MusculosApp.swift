//
//  MusculosAppApp.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import HealthKit
import Storage
import Models

struct MusculosApp: App {
  @State private var appState: AppState = .loading
  @State private var userStore = UserStore()
  @State private var exerciseStore = StorageStore<ExerciseEntity>()
  @State private var healthKitViewModel = HealthKitViewModel()
  @State private var appManager = AppManager()

  @Bindable private var navigationRouter = NavigationRouter()

  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $navigationRouter.navPath) {
        Group {
          switch appState {
          case .loading:
            SplashLoadingView()
          case .loggedOut:
            SplashView()
              .transition(.asymmetric(insertion: .opacity, removal: .identity))
          case .onboarding:
            OnboardingWizardView()
              .transition(.asymmetric(insertion: .push(from: .bottom), removal: .scale))
          case .loggedIn:
            AppTabView()
          }
        }
        .animation(.smooth(duration: UIConstant.defaultAnimationDuration), value: appState)
        .onReceive(userStore.event) { event in
          handleUserEvent(event)
        }
        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
          switch destination {
          case .exerciseDetails(let exercise):
            ExerciseDetailsView(exercise: exercise)
          }
        }
        .sheet(isPresented: navigationRouter.isPresentingBinding()) {
          if let currentSheet = navigationRouter.currentSheet {
            switch currentSheet {
            case .addActionSheet:
              AddActionSheetContainer()
            case .workoutFlow(let workout):
              WorkoutFlowView(workout: workout, onComplete: {})
            }
          }
        }
        .toastView(toast: $appManager.toast)
      }
      .task {
        await loadInitialState()
      }
      .environment(\.userStore, userStore)
      .environment(\.healthKitViewModel, healthKitViewModel)
      .environment(\.navigationRouter, navigationRouter)
      .environment(\.exerciseStore, exerciseStore)
      .environment(\.appManager, appManager)
    }
  }

  private func loadInitialState() async {
    await userStore.initialLoad()

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

extension MusculosApp {
  enum AppState {
    case loading
    case loggedOut
    case onboarding
    case loggedIn
  }
}
