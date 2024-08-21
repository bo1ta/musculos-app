//
//  Header.swift
//  
//
//  Created by Solomon Alexandru on 21.08.2024.
//

import SwiftUI
import Utility

public struct Header: View {
  let text: String
  let fontSize: CGFloat

  public init(text: String, fontSize: CGFloat = 28) {
    self.text = text
    self.fontSize = fontSize
  }

  public var body: some View {
    Text(text)
      .font(AppFont.poppins(.bold, size: fontSize))
      .fixedSize(horizontal: false, vertical: true)
      .lineLimit(3)
  }
}
