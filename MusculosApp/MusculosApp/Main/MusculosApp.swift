//
//  MusculosAppApp.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI

@main
struct MusculosApp: App {
  let coreDataStack = CoreDataStack.shared
  
  private var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
  }

  @State private var isAuthenticated = false

  var body: some Scene {
    WindowGroup {
      GeometryReader { proxy in
        if isAuthenticated {
          ContentView()
            .environment(\.managedObjectContext, self.coreDataStack.mainContext)
            .environment(\.mainWindowSize, isPreview ? CGSize(width: 375, height: 667) : proxy.size)
        } else {
          GetStartedView()
            .environment(\.mainWindowSize, proxy.size)
        }
      }
      .onAppear(perform: {
//        isAuthenticated = UserDefaultsWrapper.shared.isAuthenticated
      })
    }
  }
}
