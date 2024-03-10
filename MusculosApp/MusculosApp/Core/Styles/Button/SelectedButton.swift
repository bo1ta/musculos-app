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
      .lineLimit(0)
      .background(.white)
      .foregroundColor(isSelected ? AppColor.customRed.color : .black)
      .fontWeight(.light)
      .overlay(content: {
        RoundedRectangle(cornerRadius: 30)
                .inset(by: 1)
                .stroke(isSelected ? AppColor.customRed.color : .black)
      })
      .opacity(0.8)
  }
}
