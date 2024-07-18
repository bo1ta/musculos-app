//
//  PrimaryButtonStyle.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(14)
      .fixedSize(horizontal: false, vertical: true)
      .font(.body(.bold, size: 15.0))
      .background(Color.AppColor.blue500)
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
  }
}
