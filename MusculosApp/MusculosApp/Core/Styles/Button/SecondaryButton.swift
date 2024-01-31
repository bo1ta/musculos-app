//
//  SecondaryButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import Foundation
import SwiftUI

struct SecondaryButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.custom("Roboto-Regular", size: 16))
      .padding(16)
      .background(.white)
      .foregroundColor(.black)
      .overlay(content: {
        RoundedRectangle(cornerRadius: 30)
                .inset(by: 1)
                .stroke(.black, lineWidth: 1)
      })
      .opacity(0.8)
  }
}
