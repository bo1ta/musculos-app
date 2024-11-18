//
//  ContentSectionWithHeader.swift
//  Components
//
//  Created by Solomon Alexandru on 18.11.2024.
//

import SwiftUI
import Utility

public struct ContentSectionWithHeader<Content: View>: View {
  private let headerTitle: String
  private let scrollDirection: Axis.Set
  private let content: Content

  public init(headerTitle: String, scrollDirection: Axis.Set = .horizontal, @ViewBuilder content: () -> Content) {
    self.headerTitle = headerTitle
    self.scrollDirection = scrollDirection
    self.content = content()
  }

  public var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(headerTitle)
          .font(AppFont.spartan(.semiBold, size: 23))
        Spacer()
      }
      .padding(.vertical)

      ScrollView(scrollDirection) {
        content
      }
      .scrollIndicators(.hidden)
    }
  }
}
