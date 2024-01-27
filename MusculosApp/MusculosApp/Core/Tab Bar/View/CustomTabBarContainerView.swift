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
  let content: Content

  init(selection: Binding<TabBarItem>, tabBarItems: [TabBarItem] = [], @ViewBuilder content: () -> Content) {
    self.content = content()
    self.tabBarItems = tabBarItems
    self._selection = selection
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      content
      if !tabBarSettings.isTabBarHidden {
        CustomTabBarView(tabBarItems: tabBarItems, selection: $selection)
      }
    }
  }
}
