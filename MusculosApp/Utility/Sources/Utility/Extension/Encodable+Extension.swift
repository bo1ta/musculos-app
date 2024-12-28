//
//  Encodable+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation

public extension Encodable {
  var asDictionary: [String: Any] {
    guard let data = try? JSONEncoder().encode(self) else {
      return [:]
    }
    guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      return [:]
    }
    return dictionary
  }
}
