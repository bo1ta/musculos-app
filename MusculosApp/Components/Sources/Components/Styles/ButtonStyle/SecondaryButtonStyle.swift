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
      .font(.body(.light, size: 15))
      .padding(18)
      .fixedSize(horizontal: false, vertical: true)
      .background(.white)
      .foregroundColor(.black)
      .fontWeight(.semibold)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .shadow(radius: 1.0)
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
  }
}
