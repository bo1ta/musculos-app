//
//  CustomTabBarView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 05.08.2023.
//

import Foundation
import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedIndex: String
    private var tabBarItems: [TabBarItem]
    
    init(tabBarItems: [TabBarItem], selectedIndex: Binding<String>) {
        self.tabBarItems = tabBarItems
        self._selectedIndex = selectedIndex
    }
    
    var body: some View {
        HStack {
            ForEach(tabBarItems.indices, id: \.self) { index in
                Spacer()
                tabItem(with: tabBarItems[index], isSelected: selectedIndex == index) {
                    withAnimation(.snappy) {
                        selectedIndex = index
                    }
                }
                Spacer()
            }
        }
        .frame(height: 70)
        .background(Color(.systemGray6))
        .cornerRadius(25)
    }
}
