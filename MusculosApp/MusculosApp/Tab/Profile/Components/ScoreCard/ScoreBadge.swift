//
//  ScoreBadge.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import SwiftUI
import Utility

struct ScoreBadge: View {
  let value: Int
  let color: Color
  
  init(value: Int, color: Color = .red) {
    self.value = value
    self.color = color
  }
  
  var body: some View {
    Image(systemName: "shield.fill")
      .foregroundStyle(color)
      .font(.system(size: 65))
      .overlay(content: {
        Image(systemName: "shield.fill")
          .foregroundStyle(Gradient(colors: [.yellow, .yellow.opacity(0.8)]))
          .font(.system(size: 50))
      })
      .overlay {
        Text(String(value))
          .font(AppFont.poppins(.bold, size: 21))
          .foregroundStyle(.black)
      }
  }
}

#Preview {
  ScoreBadge(value: 87)
}
