//
//  MusculosTestBase.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import Foundation
import Models
import Storage
import Utility
import XCTest

protocol MusculosTestBase: AnyObject {}

extension MusculosTestBase {
  func parseDataFromFile(name: String, withExtension: String = "json") throws -> Data {
    guard let fileUrl = Bundle.module.url(forResource: name, withExtension: withExtension) else {
      throw NSError(domain: "FileNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "File \(name).\(withExtension) not found."])
    }
    return try Data(contentsOf: fileUrl)
  }
}
