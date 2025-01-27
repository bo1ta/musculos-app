//
//  BottomSheetSizePreferenceKey.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 27.01.2025.
//

import SwiftUI

struct BottomSheetSizePreferenceKey: PreferenceKey {
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }

  static let defaultValue: CGFloat = BottomSheetSizes.minimized
}
