//
//  PrimaryButtonStyle.swift
//  
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(18)
      .fixedSize(horizontal: false, vertical: true)
      .font(.body(.bold, size: 15.0))
      .background(Color(hex: "FF5722"))
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
  }
}
