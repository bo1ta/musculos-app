//
//  AppLauncher.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.03.2024.
//

import Foundation
import SwiftUI

@main
struct AppLauncher {
  static func main() throws {
    if isRunningUnitTests {
      TestApp.main()
    } else {
      MusculosApp.main()
    }
  }

  private static var isRunningUnitTests: Bool {
    return NSClassFromString("XCTestCase") != nil
  }
}

struct TestApp: App {
  var body: some Scene {
    WindowGroup { Text("Running unit tests") }
  }
}
