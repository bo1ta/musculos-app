//
//  ScoreCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import SwiftUI
import Utility

struct ScoreCard: View {
  let title: String
  let description: String
  let score: Int
  let onTap: () -> Void
  let badgeColor: Color

  init(
    title: String,
    description: String,
    score: Int,
    onTap: @escaping () -> Void,
    badgeColor: Color = .orange)
  {
    self.title = title
    self.description = description
    self.score = score
    self.onTap = onTap
    self.badgeColor = badgeColor
  }

  var body: some View {
    RoundedRectangle(cornerRadius: 12.0)
      .frame(maxWidth: .infinity)
      .frame(height: UIConstant.CardSize.small)
      .foregroundStyle(AppColor.navyBlue)
      .shadow(radius: 1.2)
      .overlay {
        HStack(alignment: .center) {
          VStack(alignment: .leading, spacing: 0) {
            Text(title)
              .font(AppFont.poppins(.bold, size: 22))
              .foregroundStyle(.white)
            Text(description)
              .font(AppFont.poppins(.light, size: 13))
              .foregroundStyle(.white)
              .fixedSize(horizontal: false, vertical: true)
          }
          .padding(.vertical)
          Spacer()
          ScoreBadge(value: score, color: badgeColor)
        }
        .padding([.vertical, .horizontal], 10)
      }
  }
}

#Preview {
  ScoreCard(
    title: "Fitness Score",
    description: "Based on your overview fitness tracking, your score is 87 and considered good",
    score: 87,
    onTap: { })
}
