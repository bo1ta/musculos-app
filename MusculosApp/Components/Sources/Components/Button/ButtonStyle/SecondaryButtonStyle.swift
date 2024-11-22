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
      .background(.white)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
      .shadow(radius: 1.0)
  }
}

#Preview {
  Button(action: {}, label: {
    Text("Click me")
  })
  .buttonStyle(SecondaryButtonStyle())
}
