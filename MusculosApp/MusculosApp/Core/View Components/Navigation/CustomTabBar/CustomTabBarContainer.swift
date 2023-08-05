//
//  CustomTabBarContainer.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.07.2023.
//

import SwiftUI

struct CustomTabBarContainer<Content:View>: View {
    var tabBarItems: [TabBarItem]
    let content: Content

    @State var selectedIndex: String = ""
    
    init(tabBarItems: [TabBarItem], selectedIndex: String = "", @ViewBuilder content: () -> Content) {
        self.tabBarItems = tabBarItems
        self.content = content()
        self.selectedIndex = selectedIndex
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content

            ZStack {
                CustomTabBarView(tabBarItems: tabBarItems, selectedIndex: $selectedIndex)
            }
        }
    }
}

struct CustomTabBar_Preview: PreviewProvider {
    static var previews: some View {
        CustomTabBarContainer(tabBarItems: [.dashboard, .add, .workout]) {
            Text("hi")
        }
    }
}
