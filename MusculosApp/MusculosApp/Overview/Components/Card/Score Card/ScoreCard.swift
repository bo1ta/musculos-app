//
//  ScoreCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import SwiftUI

struct ScoreCard: View {
  let title: String
  let description: String
  let score: Int
  let onTap: () -> Void
  let color: Color
  let badgeColor: Color
  
  init(title: String,
       description: String,
       score: Int,
       onTap: @escaping () -> Void,
       color: Color = Color.AppColor.blue100,
       badgeColor: Color = .green
  ) {
    self.title = title
    self.description = description
    self.score = score
    self.onTap = onTap
    self.color = color
    self.badgeColor = badgeColor
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 12.0)
      .frame(maxWidth: .infinity)
      .frame(height: 150)
      .foregroundStyle(color)
      .shadow(radius: 1.2)
      .opacity(0.8)
      .overlay {
        HStack(alignment: .top) {
          VStack(alignment: .leading, spacing: 8) {
            Text(title)
              .font(.body(.bold, size: 20))
            Text(description)
              .font(.body(.regular, size: 15))
            Button(action: onTap, label: {
              Text("Tell me more")
                .font(.body(.regular, size: 12))
            })
            .padding(.top, 10)
          }
          .padding(.trailing, 20)
          Spacer()
          ScoreBadge(value: score, color: badgeColor)
            .padding(.top, -30)
        }
        .padding([.leading, .trailing], 10)
        
      }
  }
}

#Preview {
  ScoreCard(title: "Health Score", description: "Based on your overview health tracking, your score is 87 and considered good", score: 87, onTap: {
    
  })
}
