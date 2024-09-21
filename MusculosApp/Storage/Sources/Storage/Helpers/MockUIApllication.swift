//
//  MockUIApllication.swift
//  Storage
//
//  Created by Solomon Alexandru on 21.09.2024.
//

import UIKit

public class MockUIApplication: UIApplicationProtocol {
  public nonisolated func beginBackgroundTask(withName taskName: String?, expirationHandler handler: (@MainActor () -> Void)?) -> UIBackgroundTaskIdentifier {
    return UIBackgroundTaskIdentifier.invalid
  }

  public func endBackgroundTask(_ identifier: UIBackgroundTaskIdentifier) {
  }
}
