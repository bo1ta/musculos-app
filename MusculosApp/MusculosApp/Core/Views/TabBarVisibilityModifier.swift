//
//  TabBarVisibilityModifier.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.12.2024.
//

import SwiftUI

// MARK: - TabBarVisibilityModifier

struct TabBarVisibilityModifier: ViewModifier {
  let showTabBar: Bool

  func body(content: Content) -> some View {
    content
      .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
      .preference(key: ShowTabPreferenceKey.self, value: showTabBar)
  }
}

extension View {
  func tabBarHidden() -> some View {
    modifier(TabBarVisibilityModifier(showTabBar: false))
  }
}
