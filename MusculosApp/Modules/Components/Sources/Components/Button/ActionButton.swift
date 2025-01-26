//
//  ActionButton.swift
//  Components
//
//  Created by Solomon Alexandru on 01.10.2024.
//

import SwiftUI
import Utility

public struct ActionButton: View {
  let actionType: ButtonActionType
  let buttonSize: ButtonSize
  let title: String
  let systemImageName: String?
  let onClick: () -> Void

  public init(
    actionType: ButtonActionType = .positive,
    buttonSize: ButtonSize = .medium,
    title: String,
    systemImageName: String? = nil,
    onClick: @escaping () -> Void)
  {
    self.actionType = actionType
    self.buttonSize = buttonSize
    self.title = title
    self.systemImageName = systemImageName
    self.onClick = onClick
  }

  public var body: some View {
    Button(action: onClick, label: {
      HStack {
        Spacer()

        Text(title)
          .font(AppFont.poppins(.medium, size: 17))

        Spacer()

        if let systemImageName {
          Image(systemName: systemImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 15)
            .foregroundStyle(.white.opacity(0.8))
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal)
    })
    .buttonStyle(ActionButtonStyle(actionType: actionType, buttonSize: buttonSize))
  }
}

#Preview {
  ActionButton(
    title: "Start workout",
    systemImageName: "arrow.up.right",
    onClick: { })
}
