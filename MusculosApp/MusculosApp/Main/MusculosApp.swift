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

  let coreDataStack = CoreDataStack.shared
  let coreDataManager = UserDataStore()

  var body: some Scene {
    WindowGroup {
      GeometryReader { proxy in
        if userStore.isOnboarded && userStore.isLoggedIn {
          AppTabView()
            .environment(\.managedObjectContext, self.coreDataStack.mainContext)
            .environment(\.mainWindowSize, proxy.size)
            .onAppear {
              userStore.fetchUserProfile()
            }
        } else {
          if !userStore.isLoggedIn {
            GetStartedView()
              .environment(\.mainWindowSize, proxy.size)
              .onAppear {
                userStore.initialLoad()
              }
          } else {
            OnboardingWizardView()
              .environment(\.mainWindowSize, proxy.size)
          }
        }
      }
      .environmentObject(userStore)
      .environmentObject(exerciseStore)
    }
  }
}
