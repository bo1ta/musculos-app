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
    .animation(.smooth(duration: UIConstant.defaultAnimationDuration), value: currentTab)
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
    let imageSize = isTabSelected ? UIConstant.largeIconSize : UIConstant.mediumIconSize
    let imageOpacity = isTabSelected ? 1.0 : 0.4

    Image(item.imageName)
      .renderingMode(.template)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(AppColor.orangeGradient)
      .opacity(imageOpacity)
      .frame(width: imageSize, height: imageSize)
      .scaleEffect(isTabSelected ? 1.1 : 1.0)
      .onTapGesture {
        currentTab = item
      }
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
