//
//  ImageTitleOptionsCard.swift
//  Components
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import SwiftUI
import Utility

public struct ImageTitleOptionsCard: View {
  let image: Image
  let title: String
  let options: [String]

  public init(image: Image, title: String, options: [String]) {
    self.image = image
    self.title = title
    self.options = options
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .frame(maxWidth: .infinity)
      .frame(width: 240, height: 110)
      .foregroundStyle(.white)
      .shadow(radius: 1.2)
      .overlay {
        HStack {
          image
            .resizable()
            .scaledToFit()
            .frame(width: 60)

          VStack(alignment: .leading) {
            Text(title)
              .font(AppFont.poppins(.medium, size: 15))

            Spacer()

            ForEach(options, id: \.self) { option in
              Rectangle()
                .frame(
                  width: option.widthOfString(usingFont: UIFont.systemFont(ofSize: 13)) + 20,
                  height: 30
                )
                .foregroundStyle(.gray.opacity(0.2))
                .overlay {
                  Text(option)
                    .font(AppFont.poppins(.light, size: 15))
                }
            }
          }
          .padding()

          Spacer()
        }
        .padding()
      }
  }
}

#Preview {
  ImageTitleOptionsCard(
    image: Image(systemName: "star"),
    title: "Sit ups",
    options: [
      "5 min",
      "expert"
    ]
  )
}
