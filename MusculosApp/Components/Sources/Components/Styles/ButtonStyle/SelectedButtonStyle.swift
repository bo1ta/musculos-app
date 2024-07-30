//
//  SelectedButtonStyle.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import Foundation
import SwiftUI

public struct SelectedButtonStyle: ButtonStyle {
  var isSelected: Bool

  public init(isSelected: Bool) {
    self.isSelected = isSelected
  }

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(16)
      .background(isSelected ? Color.AppColor.blue500 : .white)
      .foregroundColor(isSelected ? .white : .black)
      .font(isSelected ? .body(.bold) : .body(.regular))
      .clipShape(RoundedRectangle(cornerRadius: 25))
      .overlay(
        RoundedRectangle(cornerRadius: 25)
          .stroke(isSelected ? Color.AppColor.blue500 : .gray, lineWidth: 0.75)
      )
      .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
  }
}
