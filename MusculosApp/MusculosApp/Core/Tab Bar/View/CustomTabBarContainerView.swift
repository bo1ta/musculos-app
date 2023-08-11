//
//  CustomTabBarContainerView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.07.2023.
//

import SwiftUI

struct CustomTabBarContainerView<Content:View>: View {
    @Binding var selection: TabBarItem
    @State private var tabBarItems: [TabBarItem] = []
    let content: Content
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._selection = selection
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
            CustomTabBarView(tabBarItems: tabBarItems, selection: $selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabBarItems = value
        }
    }
}
