//
//  MusculosAppApp.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import HealthKit

struct MusculosApp: App {
  @ObservedObject private var userStore = UserStore()
  @ObservedObject private var exerciseStore = ExerciseStore()
  @ObservedObject private var healthKitViewModel = HealthKitViewModel()
  
  var body: some Scene {
    WindowGroup {
      Group {
        if userStore.isOnboarded && userStore.isLoggedIn {
          AppTabView()
            .environmentObject(exerciseStore)
        } else {
          if !userStore.isLoggedIn {
            SplashView()
              .onAppear(perform: userStore.initialLoad)
          } else {
            OnboardingWizardView()
          }
        }
      }
      .environmentObject(userStore)
      .environmentObject(healthKitViewModel)
    }
  }
}
