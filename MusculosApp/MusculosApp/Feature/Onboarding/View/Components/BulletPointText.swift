//
//  BulletPointText.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import SwiftUI

struct BulletPointText: View {
  let text: String
  let color: Color
  
  init(text: String, color: Color = Color.AppColor.blue500) {
    self.text = text
    self.color = color
  }
  
  var body: some View {
    HStack {
      Circle()
        .frame(height: 10)
        .foregroundStyle(color)
      Text(text)
    }
  }
}

#Preview {
  BulletPointText(text: "This is a bullet point")
}
