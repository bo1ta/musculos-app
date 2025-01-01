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
  public var color: Color
  public var selectionColor: Color
  public var isSelected: Bool

  public init(
    title: String,
    color: Color = .gray.opacity(0.2),
    selectionColor: Color = .orange,
    isSelected: Bool = false)
  {
    self.title = title
    self.color = color
    self.selectionColor = selectionColor
    self.isSelected = isSelected
  }

  public var body: some View {
    Rectangle()
      .frame(
        width: title.widthOfString(usingFont: UIFont.systemFont(ofSize: 13)) + 20,
        height: 30)
      .foregroundStyle(isSelected ? selectionColor : color)
      .overlay {
        Text(title)
          .font(AppFont.poppins(isSelected ? .medium : .light, size: 13))
          .foregroundStyle(isSelected ? .white : .black)
      }
  }
}
