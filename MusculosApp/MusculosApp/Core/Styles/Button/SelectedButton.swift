//
//  File.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import Foundation
import SwiftUI

struct SelectedButton: ButtonStyle {
  var isSelected: Bool
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(16)
      .background(isSelected ? Color.AppColor.blue500 : .white)
      .foregroundColor(isSelected ? .white : Color.AppColor.blue600)
      .font(isSelected ? .body(.bold) : .body(.regular))
      .clipShape(RoundedRectangle(cornerRadius: 25))
      .overlay(
        RoundedRectangle(cornerRadius: 25)
          .stroke(Color.AppColor.blue200, lineWidth: 2)
      )
      .opacity(0.8)
  }
}
