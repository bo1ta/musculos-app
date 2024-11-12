//
//  PrimaryButton.swift
//  
//
//  Created by Solomon Alexandru on 22.08.2024.
//

import SwiftUI
import Utility

public struct PrimaryButton: View {
  let title: String
  let action: () -> Void

  public init(title: String, action: @escaping () -> Void) {
    self.title = title
    self.action = action
  }

  public var body: some View {
    Button(action: action, label: {
      Text(title)
        .foregroundStyle(.white)
        .font(AppFont.poppins(.semibold, size: 18))
        .frame(maxWidth: .infinity)
        .shadow(color: .black.opacity(0.7), radius: 1)
    })
    .buttonStyle(PrimaryButtonStyle())
  }
}
