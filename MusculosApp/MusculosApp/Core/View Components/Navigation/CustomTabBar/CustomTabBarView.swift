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
            Spacer()
            ForEach(tabBarItems.indices, id: \.self) { index in
                tabItem(with: tabBarItems[index], isSelected: selectedIndex == tabBarItems[index].rawValue) {
                    withAnimation(.easeIn(duration: 0.1)) {
                        selectedIndex = tabBarItems[index].rawValue
                    }
                }
            }
            Spacer()
        }
        .frame(height: 70)
        .background(Color(.systemGray6))
        .cornerRadius(25)
    }
}

extension CustomTabBarView {
    private func tabItem(with item: TabBarItem, isSelected: Bool, onTapGesture: @escaping () -> Void) -> some View {
        VStack {
            if item == .add {
                AddTabBarButton(onTapGesture: onTapGesture)
                    .padding(.bottom)
            } else {
                Image(systemName: item.imageName)
                    .foregroundStyle(isSelected ? .black : .gray)
                    .onTapGesture(perform: onTapGesture)
                    .frame(height: 30)
                    .font(Font(CTFont(.menuItem, size: 23)))
                    .fontWeight(.bold)
            }
        }
    }
}

struct CustomTabBarView_Preview: PreviewProvider {
    static var previews: some View {
        CustomTabBarView(tabBarItems: [.dashboard, .workout, .add], selectedIndex: Binding<String>.constant(""))
    }
}
