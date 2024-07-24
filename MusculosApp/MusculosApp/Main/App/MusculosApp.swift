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
  @State private var userStore = UserStore()
  @State private var exerciseStore = StorageStore<ExerciseEntity>()
  @State private var healthKitViewModel = HealthKitViewModel()
  @Bindable private var navigationRouter = NavigationRouter()

  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $navigationRouter.navPath) {
        if userStore.isLoading {
          EmptyView()
        } else if userStore.isOnboarded && userStore.isLoggedIn {
          AppTabView()
            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
              switch destination {
              case .exerciseDetails(let exercise):
                ExerciseDetailsView(exercise: exercise)
              }
            }
            .sheet(isPresented: navigationRouter.isPresentingBinding(), content: {
              if let currentSheet = navigationRouter.currentSheet {
                switch currentSheet {
                case .addActionSheet:
                  AddActionSheetContainer()
                case .workoutFlow(let workout):
                  WorkoutFlowView(workout: workout, onComplete: {})
                }
              }
            })
        } else {
          if !userStore.isLoggedIn {
            SplashView()
          } else {
            OnboardingWizardView()
          }
        }
      }
      .task {
        await userStore.initialLoad()
      }
      .environment(\.userStore, userStore)
      .environment(\.healthKitViewModel, healthKitViewModel)
      .environment(\.navigationRouter, navigationRouter)
      .environment(\.exerciseStore, exerciseStore)
    }
  }
}
