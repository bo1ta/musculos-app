//
//  DetailCard.swift
//
//
//  Created by Solomon Alexandru on 17.08.2024.
//

import SwiftUI
import Utility

public struct DetailCard<Content: View>: View {
  let text: String
  let font: Font
  let isSelected: Bool
  let content: () -> Content

  private let horizontalPadding: CGFloat = 12.0

  public init(
    text: String,
    font: Font = AppFont.poppins(.semibold, size: 16),
    isSelected: Bool = false,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.text = text
    self.font = font
    self.isSelected = isSelected
    self.content = content
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 30)
      .foregroundStyle(LinearGradient(colors: [Color.white, Color.white.opacity(0.9)], startPoint: .top, endPoint: .bottom))
      .shadow(color: isSelected ? Color.red : .black.opacity(0.4), radius: 3)
      .overlay {
        HStack {
          Text(text)
            .font(font)
            .foregroundStyle(.black)
            .shadow(radius: 0.3)

          Spacer()

          content()
        }
        .padding(.horizontal, horizontalPadding)
      }
      .frame(maxWidth: .infinity, maxHeight: 90)
      .padding(.horizontal, horizontalPadding)
  }
}

#Preview {
  DetailCard(text: "Details here") {}
}
