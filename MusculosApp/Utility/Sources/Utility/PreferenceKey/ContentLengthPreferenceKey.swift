//
//  ContentLengthPreferenceKey.swift
//  
//
//  Created by Solomon Alexandru on 26.08.2024.
//

import SwiftUI

public struct ContentLengthPreferenceKey: PreferenceKey {
  public static var defaultValue: CGFloat { 0 }

  public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
