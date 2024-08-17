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
  let content: () -> Content

  private let horizontalPadding: CGFloat = 12.0

  public init(
    text: String,
    font: Font = AppFont.poppins(.semibold, size: 16),
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.text = text
    self.font = font
    self.content = content
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .foregroundStyle(.white)
      .shadow(radius: 2)
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
    DetailCard(text: "Details here") { }
  }
