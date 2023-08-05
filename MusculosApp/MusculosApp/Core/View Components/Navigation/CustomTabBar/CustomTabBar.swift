//
//  CustomTabBar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.07.2023.
//

import SwiftUI

struct CustomTabBar<Content:View>: View {
    var tabBarItems: [TabBarItem]
    let content: Content

    @State var selectedIndex = 0
    
    init(tabBarItems: [TabBarItem], selectedIndex: Int = 0, @ViewBuilder content: () -> Content) {
        self.tabBarItems = tabBarItems
        self.content = content()
        self.selectedIndex = selectedIndex
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            content
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
}

extension CustomTabBar {
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
                
//                Text(item.label)
//                    .font(.caption)
//                    .foregroundStyle(isSelected ? .black : .gray)
            }
        }
    }
}

struct CustomTabBar_Preview: PreviewProvider {
    static var previews: some View {
        CustomTabBar(tabBarItems: [.dashboard, .add, .workout]) {
            Text("hi")
        }
    }
}
