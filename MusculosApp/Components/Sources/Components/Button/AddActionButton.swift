//
//  AddActionButton.swift
//  Components
//
//  Created by Solomon Alexandru on 27.12.2024.
//

import SwiftUI
import Utility

// MARK: - AddActionButton

public struct AddActionButton: View {
  let action: () -> Void

  public init(action: @escaping () -> Void) {
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      RoundedRectangle(cornerRadius: 8)
        .frame(width: 33, height: 33)
        .foregroundStyle(AppColor.navyBlue)
        .overlay {
          Image(systemName: "plus")
            .foregroundStyle(.white)
        }
        .shadow(radius: 4)
    }
    .buttonStyle(AddActionButtonStyle())
  }
}

// MARK: - AddActionButtonStyle

private struct AddActionButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .buttonStyle(.plain)
      .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
      .shadow(radius: 1.0)
  }
}
