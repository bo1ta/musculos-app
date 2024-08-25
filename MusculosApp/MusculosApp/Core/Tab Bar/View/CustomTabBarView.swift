//
//  CustomTabBarView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 05.08.2023.
//

import Foundation
import SwiftUI
import Utility

struct CustomTabBarView: View {
  @Binding var currentTab: TabBarItem

  let tabBarItems: [TabBarItem]
  let onAddTapped: (() -> Void)?

  var body: some View {
    HStack(spacing: 24) {
      Spacer()
      ForEach(tabBarItems, id: \.self) { item in
        tabButton(for: item)
      }
      Spacer()
    }
    .frame(height: 70)
    .fixedSize(horizontal: true, vertical: false)
    .background(Color(.systemGray6))
    .cornerRadius(25)
    .shadow(radius: 2)
    .opacity(0.95)
  }

  private func tabButton(for item: TabBarItem) -> some View {
    Group {
      if item == .workout, let onAddTapped = onAddTapped {
        VStack {
          WorkoutTabBarButton(onTapGesture: onAddTapped)
          makeTabItemFor(item)
        }
      } else {
        makeTabItemFor(item)
      }
    }
  }

  @ViewBuilder
  private func makeTabItemFor(_ item: TabBarItem) -> some View {
    let isTabSelected = currentTab == item
    let imageSize = isTabSelected ? 30.0 : 28.0
    let imageOpacity = isTabSelected ? 1.0 : 0.4

    Image(item.imageName)
      .renderingMode(.template)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(AppColor.orangeGradient)
      .opacity(imageOpacity)
      .onTapGesture { currentTab = item }
      .frame(width: imageSize, height: imageSize)
  }
}

#Preview {
  CustomTabBarView(
    currentTab: .constant(.overview),
    tabBarItems: [.explore, .overview],
    onAddTapped: {}
  )
  .previewLayout(.sizeThatFits)
}
