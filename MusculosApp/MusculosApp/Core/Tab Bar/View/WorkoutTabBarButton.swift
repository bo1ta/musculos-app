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
    Circle()
      .foregroundStyle(.white)
      .overlay {
        Circle()
          .foregroundStyle(.black)
          .overlay {
            Image(systemName: "plus")
              .font(Font(CTFont(.menuItem, size: 18)))
              .foregroundStyle(Color.AppColor.green500)
              .onTapGesture(perform: self.onTapGesture)
          }
          .frame(width: 50, height: 50)
      }
      .frame(width: 60, height: 60)
  }
}
