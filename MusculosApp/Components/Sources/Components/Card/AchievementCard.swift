//
//  AchievementCard.swift
//  Components
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import SwiftUI
import Utility

public struct AchievementCard: View {
  let backgroundColor = AppColor.navyBlue

  public init() {}

  public var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .foregroundStyle(backgroundColor)
      .frame(maxWidth: .infinity)
      .frame(height: UIConstant.Size.small.cardHeight)
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
            Text("8 exercises left")
              .font(AppFont.poppins(.regular, size: 13))
              .foregroundStyle(.white)
          }

          Spacer()

          ProgressCircle(progress: 0.78, circleSize: 50)
        }
        .padding()
      }
  }
}

#Preview {
  AchievementCard()
}
