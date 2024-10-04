//
//  HighlightCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import SwiftUI
import Utility
import Models

struct HighlightCard: View {
  let profileHighlight: ProfileHighlight

  init(profileHighlight: ProfileHighlight) {
    self.profileHighlight = profileHighlight
  }

  var body: some View {
    RoundedRectangle(cornerRadius: 12.0)
      .frame(height: UIConstant.Size.small.cardHeight)
      .frame(maxWidth: .infinity)
      .foregroundStyle(profileHighlight.highlightType.color)
      .overlay {
        HStack(spacing: 0) {
          Image(systemName: profileHighlight.highlightType.systemImageName)
            .font(.system(size: 40))
          VStack(alignment: .leading, spacing: -5) {
            Text(profileHighlight.highlightType.title)
              .font(AppFont.poppins(.regular, size: 18))
            Text(profileHighlight.value)
              .font(AppFont.poppins(.bold, size: 20))
            Text(profileHighlight.description)
              .font(AppFont.poppins(.light, size: 16))
          }
          .padding(.horizontal)
          Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
      }
  }
}

#Preview {
  HighlightCard(profileHighlight: ProfileHighlight(highlightType: .sleep, value: "7 hr 31 min", description: "updated 10 mins ago"))
}
