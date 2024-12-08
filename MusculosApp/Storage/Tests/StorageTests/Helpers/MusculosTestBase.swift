//
//  MusculosTestBase.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import Foundation

@testable import Storage

protocol MusculosTestBase: AnyObject {}

extension MusculosTestBase {
  func clearStorage() {
    StorageContainer.shared.storageManager().reset()
  }
}
