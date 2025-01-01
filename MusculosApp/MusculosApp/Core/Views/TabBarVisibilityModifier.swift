//
//  TabBarVisibilityModifier.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.12.2024.
//

import SwiftUI

// MARK: - TabBarVisibilityModifier

struct TabBarVisibilityModifier: ViewModifier {
  let isHidden: Bool

  func body(content: Content) -> some View {
    content
      .toolbar(isHidden ? .hidden : .visible, for: .tabBar)
      .preference(key: ShowTabPreferenceKey.self, value: !isHidden)
  }
}

extension View {
  func tabBarHidden(_ isHidden: Bool = true) -> some View {
    modifier(TabBarVisibilityModifier(isHidden: isHidden))
  }
}
