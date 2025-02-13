//
//  ProgressCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import SwiftUI

struct ProgressCard: View {
  var title: String
  var description: String
  var progress: Float

  var body: some View {
    RoundedRectangle(cornerRadius: 25)
      .foregroundStyle(Color.AppColor.blue100)
      .frame(maxWidth: .infinity)
      .frame(height: 130)
      .overlay {
        VStack(alignment: .leading, spacing: 5) {
          Text(title)
            .font(.body(.medium, size: 15))
          Text(description)
            .font(.body(.regular, size: 13))
          ProgressView(value: progress)
            .tint(Color.AppColor.blue500)
            .padding(.top, 5)
        }
        .padding()
      }
      .padding()
  }
}

#Preview {
  ProgressCard(
    title: "You've completed 3 muscles",
    description: "75% of your weekly muscle building goal",
    progress: 0.75)
}
