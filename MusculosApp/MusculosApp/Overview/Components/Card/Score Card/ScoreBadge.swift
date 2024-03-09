//
//  ScoreBadge.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import SwiftUI

struct ScoreBadge: View {
  let value: Int
  let color: Color
  
  init(value: Int, color: Color = .green) {
    self.value = value
    self.color = color
  }
  
  var body: some View {
    Image(systemName: "shield.fill")
      .foregroundStyle(color)
      .font(.system(size: 80))
      .overlay {
        Text(String(value))
          .font(.custom(AppFont.bold, size: 30))
          .foregroundStyle(.white)
      }
  }
}

#Preview {
  ScoreBadge(value: 87)
}
