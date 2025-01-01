//
//  SmallCardWithContent.swift
//  Components
//
//  Created by Solomon Alexandru on 26.11.2024.
//

import SwiftUI
import Utility

public struct SmallCardWithContent<Content: View>: View {
  let title: String
  let description: String
  let gradient: LinearGradient
  let leftImageName: String?
  let rightContent: Content?

  public init(
    title: String,
    description: String,
    gradient: LinearGradient = .init(gradient: .init(colors: [.white]), startPoint: .top, endPoint: .bottom),
    leftImageName: String? = nil,
    @ViewBuilder rightContent: () -> Content)
  {
    self.title = title
    self.description = description
    self.gradient = gradient
    self.leftImageName = leftImageName
    self.rightContent = rightContent()
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 12.0)
      .frame(maxWidth: .infinity)
      .frame(height: UIConstant.Size.small.cardHeight)
      .foregroundStyle(gradient)
      .shadow(radius: 2)
      .overlay {
        HStack(alignment: .center) {
          if let leftImageName {
            Image(leftImageName)
              .resizable()
              .renderingMode(.template)
              .aspectRatio(contentMode: .fit)
              .foregroundStyle(.white)
              .frame(width: UIConstant.Size.large.iconHeight, height: UIConstant.Size.large.iconHeight)
              .padding(.leading, 3)
          }

          VStack(alignment: .leading, spacing: 0) {
            Text(title)
              .font(AppFont.poppins(.bold, size: 16))
              .foregroundStyle(.white)
            Text(description)
              .font(AppFont.poppins(.light, size: 14))
              .foregroundStyle(.white.opacity(0.9))
              .fixedSize(horizontal: false, vertical: true)
          }
          .padding([.horizontal, .vertical])
          Spacer()

          rightContent
        }
        .padding([.vertical, .horizontal], 10)
      }
  }
}
