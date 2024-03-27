//
//  StatReportCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import SwiftUI

struct StatReportCard: View {
  let emojiIcon: String
  let title: String
  let value: String
  
  init(emojiIcon: String, title: String, value: String) {
    self.emojiIcon = emojiIcon
    self.title = title
    self.value = value
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 12.0)
      .frame(maxWidth: .infinity)
      .frame(height: 130)
      .foregroundStyle(.white)
      .shadow(radius: 1.20)
      .overlay {
        VStack(alignment: .leading) {
          HStack {
            Text(emojiIcon)
              .font(.system(size: 25))
            Text(title)
              .font(.body(.regular, size: 18))
            Spacer()
          }
          Spacer()
          Text(value)
            .font(.header(.bold, size: 25))
            .foregroundStyle(.black)
            .opacity(0.7)
        }
        .padding([.top, .bottom], 30)
        .padding(.leading, 10)
      }
  }
}

#Preview {
  StatReportCard(emojiIcon: "👣", title: "Steps", value: "697,978")
}
