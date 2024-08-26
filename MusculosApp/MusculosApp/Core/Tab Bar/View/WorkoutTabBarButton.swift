//
//  WorkoutTabBarButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.08.2023.
//

import Foundation
import SwiftUI
import Utility

struct WorkoutTabBarButton: View {
  var onTapGesture: () -> Void

  init(onTapGesture: @escaping () -> Void) {
    self.onTapGesture = onTapGesture
  }

  var body: some View {
    Image("add-icon")
      .renderingMode(.template)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 30, height: 30)
      .foregroundStyle(AppColor.brightOrange)
      .onTapGesture(perform: onTapGesture)
  }
}
