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
  private let withScroll: Bool
  private let content: Content

  public init(
    headerTitle: String,
    scrollDirection: Axis.Set = .horizontal,
    withScroll: Bool = true,
    @ViewBuilder content: () -> Content)
  {
    self.headerTitle = headerTitle
    self.scrollDirection = scrollDirection
    self.withScroll = withScroll
    self.content = content()
  }

  public var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(headerTitle)
          .font(AppFont.spartan(.semiBold, size: 20))
        Spacer()
      }
      .padding(.vertical)

      if withScroll {
        ScrollView(scrollDirection) {
          content
        }
        .scrollIndicators(.hidden)
      } else {
        content
      }
    }
  }

  public struct Skeleton: View {

    private let scrollDirection: Axis.Set
    private let content: Content

    public init(
      scrollDirection: Axis.Set = .horizontal,
      @ViewBuilder content: () -> Content)
    {
      self.scrollDirection = scrollDirection
      self.content = content()
    }

    public var body: some View {
      ContentSectionWithHeader(headerTitle: "Some header title", scrollDirection: scrollDirection, content: {
        content
      })
      .redacted(reason: .placeholder)
    }
  }
}
