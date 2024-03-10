//
//  WorkoutTabBarButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.08.2023.
//

import Foundation
import SwiftUI

struct WorkoutTabBarButton: CustomTabBarButton {
  var tabBarItem: TabBarItem { .workout }
  var onTapGesture: () -> Void

  init(onTapGesture: @escaping () -> Void) {
    self.onTapGesture = onTapGesture
  }

  var body: some View {
    Circle()
      .foregroundStyle(.white)
      .overlay {
        Circle()
          .foregroundStyle(.black)
          .overlay {
            Image(systemName: self.tabBarItem.imageName)
              .font(Font(CTFont(.menuItem, size: 18)))
              .foregroundStyle(Color.AppColor.green500)
              .onTapGesture(perform: self.onTapGesture)
          }
          .frame(width: 50, height: 50)
      }
      .frame(width: 60, height: 60)
  }
}

struct AddTabBarButtonView_Preview: PreviewProvider {
  static var previews: some View {
    WorkoutTabBarButton(onTapGesture: {})
      .previewLayout(.sizeThatFits)
  }
}
