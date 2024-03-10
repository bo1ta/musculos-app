//
//  PrimaryButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import SwiftUI

struct PrimaryButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(14)
      .fixedSize(horizontal: false, vertical: true)
      .background(AppColor.blue500.color)
      .foregroundColor(.white)
      .fontWeight(.semibold)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
  }
}
