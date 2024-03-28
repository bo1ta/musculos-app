//
//  CustomNavigationBarView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import SwiftUI

struct CustomNavigationBarView: View {
  private let title: String
  private let font: Font

  init(title: String, font: Font = .title2) {
    self.title = title
    self.font = font
  }

  var body: some View {
    VStack {
      RoundedRectangle(cornerRadius: 25.0)
        .foregroundColor(.black)
        .frame(minHeight: 50)
        .frame(maxHeight: 60)
        .overlay {
          HStack {
            Spacer()

            Text(title)
              .foregroundColor(.white)
              .fontWeight(.bold)
              .font(self.font)

            Spacer()
          }
          .padding(.leading, 10)
        }
    }
  }
}

struct CustomNavigationBarView_Preview: PreviewProvider {
  static var previews: some View {
    CustomNavigationBarView(title: "Custom Navigation Bar")
      .previewLayout(.sizeThatFits)
  }
}
