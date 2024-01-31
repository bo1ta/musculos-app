//
//  ImageRectangleView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI

struct ImageRectangleView: View {
  var imageName: String
  var rectangleColor: Color
  
    var body: some View {
      Rectangle()
        .frame(height: 250)
        .foregroundStyle(rectangleColor)
        .overlay {
          Image(imageName)
            .resizable()
            .frame(maxWidth: .infinity)
            .frame(height: 250)
            .scaledToFit()
            .opacity(0.8)
        }
    }
}

#Preview {
  ImageRectangleView(imageName: "red-patterns-background", rectangleColor: Color.appColor(with: .customRed))
}
