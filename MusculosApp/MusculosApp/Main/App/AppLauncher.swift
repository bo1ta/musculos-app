//
//  AppLauncher.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.03.2024.
//

import Foundation
import SwiftUI

/// Returns a mock app when launched by unit tests
///
@main
struct AppLauncher {
  static func main() throws {
    let isRunningUnitTests = NSClassFromString("XCTestCase") != nil
    
    if isRunningUnitTests {
      TestApp.main()
    } else {
      MusculosApp.main()
    }
  }
}

struct TestApp: App {
  var body: some Scene {
    WindowGroup { Text("Running unit tests") }
  }
}
