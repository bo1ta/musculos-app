//
//  UIApplicationWrapper.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.09.2024.
//

import Utility
import UIKit

final class UIApplicationWrapper {
  nonisolated(unsafe) static var override: UIApplicationProtocol?

  nonisolated(unsafe) static var shared: UIApplicationProtocol {
    override ?? UIApplication.shared
  }
}
