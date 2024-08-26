//
//  CustomTabBarContainerView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.07.2023.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
  @Environment(\.appManager) private var appManager

  @Binding var selection: TabBarItem
  let tabBarItems: [TabBarItem]
  let onAddTapped: () -> Void
  let content: Content

  init(
    selection: Binding<TabBarItem>,
       tabBarItems: [TabBarItem],
       onAddTapped: @escaping () -> Void,
       @ViewBuilder content: () -> Content
  ) {
    self._selection = selection
    self.tabBarItems = tabBarItems
    self.onAddTapped = onAddTapped
    self.content = content()
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      content

      if !appManager.isTabBarHidden {
        CustomTabBarView(
          currentTab: $selection,
          tabBarItems: tabBarItems,
          onAddTapped: onAddTapped
        )
      }
    }
  }
}
