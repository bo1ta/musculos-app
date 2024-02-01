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
  let coreDataStack = CoreDataStack.shared

  var body: some Scene {
    WindowGroup {
      GeometryReader { proxy in
        if userStore.isOnboarded && userStore.isLoggedIn {
          ContentView()
            .environment(\.managedObjectContext, self.coreDataStack.mainContext)
            .environment(\.mainWindowSize, proxy.size)
        } else {
          if !userStore.isLoggedIn {
            GetStartedView()
              .environment(\.mainWindowSize, proxy.size)
          } else {
            OnboardingWizardView()
              .environment(\.mainWindowSize, proxy.size)
          }
        }
      }
      .environmentObject(userStore)
    }
  }
}
