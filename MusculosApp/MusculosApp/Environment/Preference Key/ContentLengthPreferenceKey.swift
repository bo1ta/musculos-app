//
//  ContentLengthPreference.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.02.2024.
//

import Foundation
import SwiftUI

struct ContentLengthPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat { 0 }
  
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
