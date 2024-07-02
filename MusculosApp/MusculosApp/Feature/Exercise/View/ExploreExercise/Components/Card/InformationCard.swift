//
//  InformationCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.06.2024.
//

import SwiftUI

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
      return Color.AppColor.green100
    case .warning:
        return Color.yellow.opacity(0.2)
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
            .font(.body(.bold, size: 17))
          Text(description)
            .font(.body(.light, size: 14))
        }
        .padding()
      }
      .padding()
  }
}

#Preview {
  InformationCard(title: "No goals tracked", description: "Setting new goals will help you grow", style: .general)
}
