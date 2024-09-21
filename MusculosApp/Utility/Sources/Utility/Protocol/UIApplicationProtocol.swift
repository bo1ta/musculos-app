//
//  UIApplicationProtocol.swift
//  Utility
//
//  Created by Solomon Alexandru on 21.09.2024.
//

import UIKit

public protocol UIApplicationProtocol {
  func beginBackgroundTask(withName taskName: String?, expirationHandler handler: (@MainActor @Sendable () -> Void)?) -> UIBackgroundTaskIdentifier
  func endBackgroundTask(_ identifier: UIBackgroundTaskIdentifier)
}

extension UIApplication: UIApplicationProtocol {}
