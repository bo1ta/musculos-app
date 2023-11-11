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

  var body: some Scene {
    WindowGroup {
      GeometryReader { proxy in
        ContentView()
          .environment(\.managedObjectContext, self.coreDataStack.mainContext)
          .environment(\.mainWindowSize, isPreview ? CGSize(width: 375, height: 667) : proxy.size)
      }
    }
  }
}
