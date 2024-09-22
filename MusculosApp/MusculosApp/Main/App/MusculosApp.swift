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
import Components
import Utility

struct MusculosApp: App {
  enum AppState {
    case loading
    case loggedOut
    case onboarding
    case loggedIn
  }
  @State private var appState: AppState = .loading
  @State private var progress: Double = 0.0
  @State private var userStore = UserStore()
  @State private var healthKitViewModel = HealthKitViewModel()

  @Bindable private var navigationRouter = NavigationRouter()

  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $navigationRouter.navPath) {
        Group {
          switch appState {
          case .loading:
            LoadingOverlayView(progress: $progress)
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
        .onReceive(userStore.eventPublisher) { event in
          handleUserEvent(event)
        }
        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
          getViewForDestination(destination)
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
      }
      .task {
        await loadInitialState()
      }
      .environment(\.userStore, userStore)
      .environment(\.healthKitViewModel, healthKitViewModel)
      .environment(\.navigationRouter, navigationRouter)
    }
  }

  @ViewBuilder
  private func getViewForDestination(_ destination: NavigationRouter.Destination) -> some View {
    switch destination {
    case .exerciseDetails(let exercise):
      ExerciseDetailsView(exercise: exercise)
    case .search:
      EmptyView()
    case .notifications:
      EmptyView()
    case .filteredByGoal(let goal):
      EmptyView()
    }
  }

  private func loadInitialState() async {
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
