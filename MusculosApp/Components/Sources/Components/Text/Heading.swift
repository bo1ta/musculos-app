//
//  Header.swift
//  
//
//  Created by Solomon Alexandru on 21.08.2024.
//

import SwiftUI
import Utility

public struct Heading: View {
  let text: String
  let fontSize: CGFloat
  let fontColor: Color

  public init(_ text: String, fontSize: CGFloat = 28, fontColor: Color = .black) {
    self.text = text
    self.fontSize = fontSize
    self.fontColor = fontColor
  }

  public var body: some View {
    Text(text)
      .font(AppFont.poppins(.bold, size: fontSize))
      .fixedSize(horizontal: false, vertical: true)
      .lineLimit(3)
      .foregroundStyle(fontColor)
  }
}
