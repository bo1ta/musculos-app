//
//  ActionButtonStyle.swift
//  Components
//
//  Created by Solomon Alexandru on 01.10.2024.
//

import SwiftUI
import Utility

public struct ActionButtonStyle: ButtonStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(13)
      .fixedSize(horizontal: false, vertical: true)
      .background(AppColor.navyBlue)
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
      .shadow(radius: 1.0)
  }
}

#Preview {
  Button(action: {}, label: {
    Text("Click me")
  })
  .buttonStyle(ActionButtonStyle())
}
