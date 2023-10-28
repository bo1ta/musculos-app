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

  var body: some Scene {
    WindowGroup {
      GeometryReader { proxy in
        ContentView()
          .environment(\.managedObjectContext, self.coreDataStack.mainContext)
          .environment(\.mainWindowSize, proxy.size)
      }
    }
  }
}
