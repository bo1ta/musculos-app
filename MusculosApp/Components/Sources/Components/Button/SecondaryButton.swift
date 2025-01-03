//
//  SecondaryButton.swift
//
//
//  Created by Solomon Alexandru on 22.08.2024.
//

import SwiftUI
import Utility

public struct SecondaryButton: View {
  let title: String
  let action: () -> Void

  public init(title: String, action: @escaping () -> Void) {
    self.title = title
    self.action = action
  }

  public var body: some View {
    Button(action: action, label: {
      Text(title)
        .font(AppFont.poppins(.regular, size: 18))
        .frame(maxWidth: .infinity)
        .shadow(color: .black.opacity(0.7), radius: 1)
    })
    .buttonStyle(SecondaryButtonStyle())
  }
}
