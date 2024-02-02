//
//  PrimaryButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import SwiftUI

struct PrimaryButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(16)
      .fixedSize(horizontal: false, vertical: true)
      .background(Color.appColor(with: .customRed))
      .foregroundColor(.white)
      .fontWeight(.semibold)
      .clipShape(RoundedRectangle(cornerSize: CGSize(width: 24, height: 20)))
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
  }
}
