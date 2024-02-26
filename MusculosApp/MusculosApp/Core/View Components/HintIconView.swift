//
//  HintIconView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.02.2024.
//

import SwiftUI

struct HintIconView: View {
  var imageName: String?
  var systemImage: String?
  var textHint: String
  
  init(imageName: String? = nil, systemImage: String? = nil, textHint: String) {
    self.imageName = imageName
    self.systemImage = systemImage
    self.textHint = textHint
  }
  
  var body: some View {
    VStack {
      Group {
        if let imageName {
          Image(imageName)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
        } else if let systemImage {
          Image(systemName: systemImage)
            .resizable()
            .scaledToFit()
        }
      }
      .frame(width: 40, height: 40)
      .opacity(0.3)
      .foregroundStyle(.gray)
      Text(textHint)
        .font(.callout)
        .fontWeight(.regular)
        .italic()
        .opacity(0.3)
    }
  }
}

#Preview {
  HintIconView(textHint: "No challenges completed yet")
}
