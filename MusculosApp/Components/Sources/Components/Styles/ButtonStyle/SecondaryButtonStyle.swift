//
//  SecondaryButtonStyle.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import Foundation
import SwiftUI

public struct SecondaryButtonStyle: ButtonStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(10)
      .fixedSize(horizontal: false, vertical: true)
      .background(
        LinearGradient(
          colors: [
            Color.white,
            Color.white.opacity(0.90)
          ],
          startPoint: .top,
          endPoint: .bottom
        )
      )
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 30))
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .shadow(color: .black.opacity(0.8), radius: 1)
  }
}
