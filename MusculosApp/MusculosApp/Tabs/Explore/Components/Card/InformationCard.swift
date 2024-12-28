//
//  InformationCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.06.2024.
//

import SwiftUI
import Utility

struct InformationCard: View {
  enum InformationStyle {
    case general
    case warning
  }

  var title: String
  var description: String
  var style: InformationStyle

  var cardColor: Color {
    switch style {
    case .general:
      return Color.AppColor.green700
    case .warning:
      return Color.yellow
    }
  }

  var body: some View {
    RoundedRectangle(cornerRadius: 25)
      .foregroundStyle(cardColor)
      .frame(maxWidth: .infinity)
      .frame(height: 130)
      .overlay {
        VStack(alignment: .center, spacing: 5) {
          Text(title)
            .font(AppFont.poppins(.bold, size: 14))
            .foregroundStyle(.white)
            .shadow(radius: 1.2)
          Text(description)
            .font(AppFont.poppins(.regular, size: 13))
            .foregroundStyle(.white)
            .shadow(radius: 1.2)
        }
        .padding()
      }
      .padding()
  }
}

#Preview {
  InformationCard(title: "No goals tracked", description: "Setting new goals will help you grow", style: .warning)
}
