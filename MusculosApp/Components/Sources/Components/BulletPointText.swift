//
//  BulletPointText.swift
//  
//
//  Created by Solomon Alexandru on 21.08.2024.
//

import SwiftUI
import Utility

public struct BulletPointText: View {
  let text: String
  let color: Color

  public init(text: String, color: Color = Color.AppColor.blue500) {
    self.text = text
    self.color = color
  }

  public var body: some View {
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
