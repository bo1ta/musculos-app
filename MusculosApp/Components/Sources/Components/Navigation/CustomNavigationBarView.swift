//
//  CustomNavigationBarView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import SwiftUI

public struct CustomNavigationBarView: View {
  private let title: String
  private let font: Font

  public init(title: String, font: Font = .title2) {
    self.title = title
    self.font = font
  }

  public var body: some View {
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

#Preview {
  CustomNavigationBarView(title: "Custom Navigation Bar")
}
