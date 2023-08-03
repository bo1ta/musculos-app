//
//  CustomTabBar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.07.2023.
//

import SwiftUI

enum TabBarItemIcon: String {
    case dashboard = "rectangle.grid.2x2"
    case workout = "dumbbell"
    case add = "plus"
}

struct CustomTabBar: View {
    var tabBarItems: [TabBarItemIcon] = [.dashboard, .add, .workout]
    
    @State var selectedIndex = 0
    
    var body: some View {
        HStack {
            ForEach(tabBarItems.indices, id: \.self) { index in
                Image(systemName: tabBarItems[index].rawValue)
                    .foregroundColor(selectedIndex == index ? .purple : .black)
                    .onTapGesture {
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
    }
}

struct CustomTabBar_Preview: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
            .previewLayout(.sizeThatFits)
    }
}
