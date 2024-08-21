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
        .font(AppFont.poppins(.bold, size: 18))
        .frame(maxWidth: .infinity)
    })
    .buttonStyle(PrimaryButtonStyle())
  }
}
