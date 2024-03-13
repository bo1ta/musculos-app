//
//  CustomTabBarContainerView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.07.2023.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
  @Binding var selection: TabBarItem
  @EnvironmentObject var tabBarSettings: TabBarSettings
  
  private var tabBarItems: [TabBarItem] = []
  private let onAddTapped: () -> Void
  private let content: Content

  init(selection: Binding<TabBarItem>, tabBarItems: [TabBarItem] = [], onAddTapped: @escaping () -> Void, @ViewBuilder content: () -> Content) {
    self.content = content()
    self.tabBarItems = tabBarItems
    self.onAddTapped = onAddTapped
    self._selection = selection
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      content
      if !tabBarSettings.isTabBarHidden {
        CustomTabBarView(tabBarItems: tabBarItems, selection: $selection, onAddTapped: onAddTapped)
      }
    }
  }
}
