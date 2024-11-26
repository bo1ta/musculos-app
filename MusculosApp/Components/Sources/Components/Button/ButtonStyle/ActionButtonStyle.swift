//
//  ActionButtonStyle.swift
//  Components
//
//  Created by Solomon Alexandru on 01.10.2024.
//

import SwiftUI
import Utility

public struct ActionButtonStyle: ButtonStyle {
  let actionType: ButtonActionType
  let buttonSize: ButtonSize

  public init(actionType: ButtonActionType = .positive, buttonSize: ButtonSize = .medium) {
    self.actionType = actionType
    self.buttonSize = buttonSize
  }

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(buttonSize.labelPadding)
      .fixedSize(horizontal: false, vertical: true)
      .background(buttonColor)
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
      .shadow(radius: 1.0)
  }

  private var buttonColor: Color {
    switch actionType {
    case .positive: return AppColor.navyBlue
    case .negative: return .red
    }
  }
}

#Preview {
  Button(action: {}, label: {
    Text("Click me")
  })
  .buttonStyle(ActionButtonStyle())
}
