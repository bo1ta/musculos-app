//
//  CustomTabBarView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 05.08.2023.
//

import Foundation
import SwiftUI

struct CustomTabBarView: View {
  @Namespace private var namespace
  @Binding var selection: TabBarItem
  
  private let tabBarItems: [TabBarItem]
  private let onAddTapped: (() -> Void)?
  
  init(tabBarItems: [TabBarItem],
       selection: Binding<TabBarItem>,
       onAddTapped: (() -> Void)? = nil) {
    self.tabBarItems = tabBarItems
    self._selection = selection
    self.onAddTapped = onAddTapped
  }
  
  var body: some View {
    HStack(spacing: 24) {
      Spacer()
      ForEach(tabBarItems.indices, id: \.self) { index in
        if let onAddTapped, index == tabBarItems.count / 2 {
          WorkoutTabBarButton(onTapGesture: onAddTapped)
            .padding(.bottom, 20)
        }
        tabItem(with: tabBarItems[index],
                isSelected: selection == tabBarItems[index],
                onTapGesture: {
          selection = tabBarItems[index]
        })
      }
      Spacer()
    }
    .frame(height: 70)
    .fixedSize(horizontal: true, vertical: false)
    .background(Color(.systemGray6))
    .cornerRadius(25)
    .shadow(radius: 2)
  }
}

extension CustomTabBarView {
  private func tabItem(with item: TabBarItem,
                       isSelected: Bool,
                       onTapGesture: @escaping () -> Void) -> some View {
    Image(systemName: item.imageName)
      .foregroundStyle(isSelected ? .black : .gray)
      .onTapGesture(perform: onTapGesture)
      .frame(height: 30)
      .font(Font(CTFont(.menuItem, size: 23)))
      .fontWeight(.bold)
  }
}

struct CustomTabBarView_Preview: PreviewProvider {
  static var previews: some View {
    CustomTabBarView(tabBarItems: [.overview, .overview], selection: Binding<TabBarItem>.constant(.overview), onAddTapped: {})
      .previewLayout(.sizeThatFits)
  }
}
