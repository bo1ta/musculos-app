//
//  AchievementCard.swift
//  Components
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import SwiftUI
import Utility

public struct AchievementCard: View {
  private let title: String
  private let progress: Double

  public init(title: String, progress: Double) {
    self.title = title
    self.progress = progress
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .foregroundStyle(AppColor.navyBlue)
      .frame(maxWidth: .infinity)
      .frame(height: UIConstant.CardSize.small)
      .shadow(radius: 1.0)
      .overlay {
        HStack {
          Image("trophy-icon")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .rotationEffect(.degrees(27))
            .foregroundStyle(Gradient(colors: [.yellow, .orange, .purple]))

          VStack(alignment: .leading, spacing: 1) {
            Heading("Achievements & Progress", fontSize: 16, fontColor: .white)
            Text(title)
              .font(AppFont.body(.regular, size: 13))
              .foregroundStyle(.white)
          }

          Spacer()

          ProgressCircle(progress: progress, circleSize: 50)
        }
        .padding()
      }
  }
}

#Preview {
  AchievementCard(title: "7 exercises left", progress: 0.75)
}
