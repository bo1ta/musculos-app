//
//  ShowTabPreferenceKey.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.12.2024.
//

import SwiftUI

struct ShowTabPreferenceKey: PreferenceKey {
  nonisolated(unsafe) static var defaultValue: Bool = true

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    value = nextValue()
  }
}
