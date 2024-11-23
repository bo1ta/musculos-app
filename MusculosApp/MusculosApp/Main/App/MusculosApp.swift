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
import Factory
import NetworkClient
import Network

struct MusculosApp: App {
  @Injected(\NetworkContainer.networkMonitor) private var networkMonitor: NetworkMonitorProtocol

  @State private var appState: AppState = .loading
  @State private var progress: Double = 0.0
  @State private var userStore = UserStore()
  @State private var healthKitViewModel = HealthKitViewModel()
  @State private var toast: Toast? = nil

  @Bindable private var navigationRouter = NavigationRouter()

  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $navigationRouter.navPath) {
        Group {
          switch appState {
          case .loggedIn:
            AppTabView()
          case .loggedOut:
            SplashScreen()
              .transition(.asymmetric(insertion: .opacity, removal: .identity))
          case .onboarding:
            OnboardingScreen()
              .transition(.asymmetric(insertion: .push(from: .bottom), removal: .scale))
          case .loading:
            LoadingOverlayView(progress: $progress)
          }
        }
        .animation(.smooth(duration: UIConstant.mediumAnimationDuration), value: appState)
        .onReceive(userStore.eventPublisher, perform: handleUserEvent(_:))
        .onReceive(networkMonitor.connectionStatusPublisher, perform: handleConnectionStatusUpdate(_:))
        .navigationDestination(for: NavigationRouter.Destination.self, destination: getViewForDestination(_:))
        .sheet(isPresented: navigationRouter.isPresentingBinding(), content: getSheetView)
        .toastView(toast: $toast)
      }
      .task {
        networkMonitor.startMonitoring()
        await loadInitialState()
      }
      .environment(\.userStore, userStore)
      .environment(\.healthKitViewModel, healthKitViewModel)
      .environment(\.navigationRouter, navigationRouter)
    }
  }

  @MainActor
  private func handleConnectionStatusUpdate(_ connectionStatus: NWPath.Status) {
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

  @MainActor
  @ViewBuilder
  private func getViewForDestination(_ destination: NavigationRouter.Destination) -> some View {
    switch destination {
    case .exerciseDetails(let exercise):
      ExerciseDetailsScreen(exercise: exercise)
    case .exerciseListByGoal(let workoutGoal):
      ExerciseListView(filterType: .filteredByWorkoutGoal(workoutGoal))
    case .exerciseListByMuscleGroup(let muscleGroup):
      ExerciseListView(filterType: .filteredByMuscleGroup(muscleGroup))
    case .search:
      EmptyView()
    case .notifications:
      EmptyView()
    case .filteredByGoal(let goal):
      EmptyView()
    }
  }

  @MainActor
  @ViewBuilder
  private func getSheetView() -> some View {
    if let currentSheet = navigationRouter.currentSheet {
      switch currentSheet {
      case .addActionSheet:
        AddActionSheetContainer()
      case .addGoalSheet:
        AddGoalSheet()
      case .workoutFlow(let workout):
        WorkoutFlowView(workout: workout, onComplete: {})
      }
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

  @MainActor
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
  private enum AppState {
    case loggedIn
    case loggedOut
    case onboarding
    case loading
  }
}
