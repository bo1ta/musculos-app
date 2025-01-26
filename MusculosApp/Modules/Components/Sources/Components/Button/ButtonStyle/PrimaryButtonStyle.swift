//
//  PrimaryButtonStyle.swift
//
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import SwiftUI
import Utility

public struct PrimaryButtonStyle: ButtonStyle {
  public init() { }

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(10)
      .fixedSize(horizontal: false, vertical: true)
      .background(
        LinearGradient(colors: [AppColor.lightBrown.opacity(0.8), AppColor.lightBrown], startPoint: .center, endPoint: .bottom))
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 30))
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .shadow(color: .orange.opacity(0.8), radius: 4)
  }
}

#Preview {
  Button(action: { }, label: {
    Text("Primary Button")
  })
  .buttonStyle(PrimaryButtonStyle())
}
