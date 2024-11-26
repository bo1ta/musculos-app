//
//  ContentTitleOptionsCard.swift
//  Components
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import SwiftUI
import Utility

public struct ContentTitleOptionsCard<Content: View>: View {
  let content: Content
  let title: String
  let options: [String]

  public init(title: String, options: [String], @ViewBuilder content: @escaping () -> Content) {
    self.title = title
    self.options = options
    self.content = content()
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .frame(maxWidth: .infinity)
      .frame(width: 240, height: 110)
      .foregroundStyle(.white)
      .overlay {
        HStack {
          content

          Spacer()

          VStack(alignment: .leading) {
            Text(title)
              .font(AppFont.poppins(.medium, size: 14))
              .fixedSize(horizontal: false, vertical: true)
              .multilineTextAlignment(.center)
              .shadow(radius: 1)

            ForEach(options, id: \.self) { option in
              TextResizablePill(title: option)
            }
          }
          .padding(.leading)

          Spacer()
        }
      }
  }
}

#Preview {
  ContentTitleOptionsCard(title: "My custom title", options: ["option 1", "option 2", "option 3"], content: {
    Image(systemName: "chevron.left")
  })
}
