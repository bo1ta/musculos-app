//
//  HighlightCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import SwiftUI

struct HighlightCard: View {
  let title: String
  let value: String
  let description: String
  let imageName: String
  let color: Color
  
  init(title: String, value: String, description: String, imageName: String, color: Color = .cyan)  {
    self.title = title
    self.value = value
    self.description = description
    self.imageName = imageName
    self.color = color
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 12.0)
      .frame(height: 180)
      .frame(maxWidth: .infinity)
      .foregroundStyle(color)
      .overlay {
        Group {
          VStack(alignment: .leading) {
            HStack {
              Spacer()
              Image(systemName: imageName)
                .font(.system(size: 40))
            }
            .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 3) {
              Text(title)
                .font(.custom(AppFont.bold, size: 15))
              Text(value)
                .font(.custom(AppFont.regular, size: 18))
              Text(description)
                .font(.custom(AppFont.regular, size: 10))
            }
          }
          .padding([.leading, .trailing], 10)
        }
        .foregroundStyle(.white)
      }
  }
}

#Preview {
  HighlightCard(title: "Steps", value: "11,857", description: "updated 15 min ago", imageName: "dumbbell.fill")
}
