//
//  IconButton.swift
//  Components
//
//  Created by Solomon Alexandru on 26.11.2024.
//

import SwiftUI
import Utility

public struct IconButton: View {
  private let systemImageName: String
  private let action: () -> Void

  public init(systemImageName: String, action: @escaping () -> Void) {
    self.systemImageName = systemImageName
    self.action = action
  }

  public var body: some View {
    Button(action: action, label: {
      Circle()
        .frame(height: 35)
        .padding()
        .foregroundStyle(.white.opacity(0.2))
        .overlay {
          Image(systemName: systemImageName)
            .font(.subheadline)
            .foregroundStyle(.white)
        }
    })
  }
}
