//
//  CustomTabBar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.07.2023.
//

import SwiftUI

struct CustomTabBar: View {
    var tabBarItems: [TabBarItem] = [.dashboard, .add, .workout]
    
    @State var selectedIndex = 0
    
    var body: some View {
        ZStack(alignment: .bottom, content: {
            HStack {
                ForEach(tabBarItems.indices, id: \.self) { index in
                    tabItem(with: tabBarItems[index], isSelected: selectedIndex == index) {
                        withAnimation(.easeInOut) {
                            selectedIndex = index
                        }
                    }
                    if tabBarItems[index] != tabBarItems.last {
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(25)
        })
    }
    
    private func tabItem(with item: TabBarItem, isSelected: Bool, onTapGesture: @escaping () -> Void) -> some View {
        VStack(spacing: 0) {
            if item == .add {
                ZStack(alignment: .top) {
                    AddTabBarButton(onTapGesture: onTapGesture)
                }
            } else {
                Image(systemName: item.imageName)
                    .foregroundStyle(isSelected ? Color.appColor(with: .violetBlue) : .gray)
                    .onTapGesture(perform: onTapGesture)
                    .frame(height: 30)
                    .font(Font(CTFont(.menuItem, size: 23)))
                
                Text(item.label)
                    .font(.caption)
                    .foregroundStyle(isSelected ? Color.appColor(with: .violetBlue) : .gray)
            }
        }
    }
}

struct CustomTabBar_Preview: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
            .previewLayout(.sizeThatFits)
    }
}
