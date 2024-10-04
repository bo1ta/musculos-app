//
//  TextResizablePill.swift
//  Components
//
//  Created by Solomon Alexandru on 04.10.2024.
//

import SwiftUI
import Utility

public struct TextResizablePill: View {
  public var title: String

  public init(title: String) {
    self.title = title
  }

  public var body: some View {
    Rectangle()
      .frame(
        width: title.widthOfString(usingFont: UIFont.systemFont(ofSize: 13)) + 20,
        height: 30
      )
      .foregroundStyle(.gray.opacity(0.2))
      .overlay {
        Text(title)
          .font(AppFont.poppins(.light, size: 13))
      }
  }
}
