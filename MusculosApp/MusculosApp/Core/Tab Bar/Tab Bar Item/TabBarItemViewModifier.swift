//
//  TabBarItemViewModifier.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.08.2023.
//

import Foundation
import SwiftUI

struct TabBarItemViewModifier: ViewModifier {
  let tab: TabBarItem
  @Binding var selection: TabBarItem

  func body(content: Content) -> some View {
    content
      .opacity(selection == tab ? 1.0 : 0.0)
      .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
  }
}
