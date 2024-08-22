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
        .font(AppFont.poppins(.semibold, size: 18))
        .frame(maxWidth: .infinity)
        .shadow(radius: 2)
    })
    .buttonStyle(SecondaryButtonStyle())
  }
}
