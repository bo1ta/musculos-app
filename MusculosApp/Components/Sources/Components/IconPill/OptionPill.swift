//
//  OptionPill.swift
//  Components
//
//  Created by Solomon Alexandru on 01.10.2024.
//

import SwiftUI
import Utility

public struct OptionPill: View {
  let title: String

  public init(title: String) {
    self.title = title
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 5)
      .frame(width: 80, height: 20)
      .foregroundStyle(.white)
      .overlay(content: {
        RoundedRectangle(cornerRadius: 5)
          .stroke(.gray, lineWidth: 1)
          .frame(width: 80, height: 20)
      })
      .overlay {
        Text(title)
          .font(AppFont.poppins(.light, size: 12))
      }
  }
}

#Preview {
  OptionPill(title: "biceps")
}
