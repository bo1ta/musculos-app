//
//  ChallengeCard.swift
//  Components
//
//  Created by Solomon Alexandru on 24.09.2024.
//

import SwiftUI
import Utility

public struct ChallengeCard: View {
  private let label: String
  private let subLabel: String?
  private let level: String
  private let icon: Image?
  private let iconColor: Color
  private let cardColor: Color

  public init(
    label: String,
    subLabel: String? = nil,
    level: String,
    icon: Image? = nil,
    iconColor: Color = .white,
    cardColor: Color = .blue)
  {
    self.label = label
    self.subLabel = subLabel
    self.level = level
    self.icon = icon
    self.iconColor = iconColor
    self.cardColor = cardColor
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .frame(width: 140, height: 140)
      .foregroundStyle(cardColor)
      .overlay {
        VStack(alignment: .leading) {
          HStack {
            Spacer()

            RoundedRectangle(cornerRadius: 10)
              .frame(width: 80, height: 20)
              .foregroundStyle(AppColor.navyBlue)
              .overlay {
                Text(level)
                  .foregroundStyle(.white)
                  .font(AppFont.poppins(.light, size: 11))
              }
          }

          Spacer()

          Group {
            if let icon {
              icon
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 55, height: 55)
                .foregroundStyle(iconColor)
                .shadow(radius: 1.0)
            }

            Text(label)
              .lineLimit(2)
              .font(AppFont.poppins(.regular, size: 17))
              .fixedSize(horizontal: false, vertical: true)
              .foregroundStyle(.white)

            if let subLabel {
              Text(subLabel)
                .font(AppFont.poppins(.light, size: 12))
                .foregroundStyle(.white)
            }
          }
          .padding(.leading)

          Spacer()
        }
      }
  }
}

#Preview {
  ChallengeCard(label: "Push up challenge", subLabel: "quick workout", level: "expert", icon: Image(systemName: "star"))
}
