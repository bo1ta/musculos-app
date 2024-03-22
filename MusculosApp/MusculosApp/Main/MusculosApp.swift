//
//  MusculosAppApp.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI

@main
struct MusculosApp: App {
  @ObservedObject private var userStore = UserStore()
  @ObservedObject private var exerciseStore = ExerciseStore()

  var body: some Scene {
    WindowGroup {
      GeometryReader { proxy in
        if userStore.isOnboarded && userStore.isLoggedIn {
          AppTabView()
            .onAppear {
              userStore.fetchUserProfile()
            }
            .environmentObject(exerciseStore)
        } else {
          if !userStore.isLoggedIn {
            SplashView()
              .onAppear {
                userStore.initialLoad()
              }
          } else {
            OnboardingWizardView()
          }
        }
      }
      .environmentObject(userStore)
    }
  }
}
