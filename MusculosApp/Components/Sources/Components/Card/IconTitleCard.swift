//
//  IconTitleCard.swift
//  Components
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import SwiftUI
import Utility

public struct IconTitleCard: View {
  private let icon: Image
  private let imageColor: Color
  private let title: String

  public init(icon: Image, imageColor: Color = .black, title: String) {
    self.icon = icon
    self.imageColor = imageColor
    self.title = title
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 20)
      .frame(width: 120, height: 100)
      .foregroundStyle(.white)
      .shadow(radius: 1.0)
      .overlay {
        VStack(alignment: .center) {
          icon
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .foregroundStyle(imageColor)
            .frame(width: 30)
          Text(title)
            .font(AppFont.poppins(.light, size: 14))
            .lineLimit(nil)
        }
        .padding()
      }
  }
}

#Preview {
  IconTitleCard(icon: Image(systemName: "chevron.right"), title: "General")
}
