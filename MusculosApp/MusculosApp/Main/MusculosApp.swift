//
//  MusculosAppApp.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import HealthKit

struct MusculosApp: App {
  @StateObject private var userStore = UserStore()
  @StateObject private var healthKitViewModel = HealthKitViewModel()
  
  var body: some Scene {
    WindowGroup {
      Group {
        if userStore.isOnboarded && userStore.isLoggedIn {
          AppTabView()
        } else {
          if !userStore.isLoggedIn {
            SplashView()
              .task {
                await userStore.initialLoad()
              }
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
