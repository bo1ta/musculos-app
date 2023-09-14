//
//  XCTestCase+Extension.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import Foundation
import XCTest

extension XCTestCase {
    func readFromFile(name: String, withExtension: String = "json") throws -> Data {
        let bundle = Bundle(for: (type(of: self)))
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try Data(contentsOf: fileUrl!)
        return data
    }
}
