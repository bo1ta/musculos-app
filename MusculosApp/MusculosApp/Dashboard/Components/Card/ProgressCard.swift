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
      .foregroundStyle(Color.appColor(with: .lightGrey))
      .frame(maxWidth: .infinity)
      .frame(minHeight: 130)
      .overlay {
        VStack(alignment: .leading, spacing: 5) {
          Text(title)
            .font(.custom(AppFont.medium, size: 19))
          Text(description)
            .font(.custom(AppFont.regular, size: 16))
          ProgressView(value: progress)
            .tint(Color.appColor(with: .customRed))
            .padding(.top, 5)
        }
        .padding()
      }
      .padding()
  }
}

#Preview {
  ProgressCard(title: "You've completed 3 muscles", description: "75% of your weekly muscle building goal", progress: 0.75)
}
