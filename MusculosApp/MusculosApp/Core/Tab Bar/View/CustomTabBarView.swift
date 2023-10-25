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
  private var tabBarItems: [TabBarItem]

  init(tabBarItems: [TabBarItem], selection: Binding<TabBarItem>) {
    self.tabBarItems = tabBarItems
    self._selection = selection
  }

  var body: some View {
    HStack(spacing: 24) {
      Spacer()
      ForEach(tabBarItems.indices, id: \.self) { index in
        tabItem(with: tabBarItems[index],
            isSelected: selection.rawValue == tabBarItems[index].rawValue) {
          withAnimation(.easeIn(duration: 0.1)) {
            selection = tabBarItems[index]
          }
        }
      }
      Spacer()
    }
    .frame(height: 70)
    .fixedSize(horizontal: true, vertical: false)
    .background(Color(.systemGray6))
    .cornerRadius(25)
  }
}

extension CustomTabBarView {
  private func tabItem(with item: TabBarItem, isSelected: Bool, onTapGesture: @escaping () -> Void) -> some View {
    VStack {
      if item == .add {
        AddTabBarButtonView(onTapGesture: onTapGesture)
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
    CustomTabBarView(tabBarItems: [.dashboard, .add, .workout], selection: Binding<TabBarItem>.constant(.dashboard))
      .previewLayout(.sizeThatFits)
  }
}
