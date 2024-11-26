//
//  TitleCard.swift
//  Components
//
//  Created by Solomon Alexandru on 13.11.2024.
//

import SwiftUI
import Utility

public struct TitleCard: View {
  private let title: String
  private let titleColor: Color
  private let cardColor: Color

  public init(title: String, titleColor: Color = .black, cardColor: Color = .white) {
    self.title = title
    self.titleColor = titleColor
    self.cardColor = cardColor
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 20)
      .frame(width: 120, height: 100)
      .foregroundStyle(cardColor)
      .shadow(radius: 1.0)
      .overlay {
        VStack(alignment: .center) {
          Text(title)
            .font(AppFont.poppins(.regular, size: 15))
            .lineLimit(nil)
            .minimumScaleFactor(0.85)
            .foregroundStyle(titleColor)
        }
        .padding(.vertical)
      }
  }
}

#Preview {
  TitleCard(title: "General")
}
