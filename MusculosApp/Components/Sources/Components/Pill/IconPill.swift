//
//  IconPill.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI
import Utility

// MARK: - IconPillSize

public enum IconPillSize {
  case small, medium, large
}

// MARK: - IconPill

public struct IconPill: View {
  private let option: IconPillOption
  private let iconPillSize = IconPillSize.small
  private let backgroundColor: Color

  public init(option: IconPillOption, backgroundColor: Color = .black) {
    self.option = option
    self.backgroundColor = backgroundColor
  }

  private var systemImageSize: CGFloat {
    guard option.systemImage != nil else {
      return 0
    }

    /// `ImageScale.small
    return 40.0
  }

  private var fontSizeWidth: CGFloat {
    option.title.widthOfString(usingFont: .systemFont(ofSize: 12))
  }

  private var rectangleWidth: CGFloat {
    switch iconPillSize {
    case .small:
      return (systemImageSize + fontSizeWidth + 20) / 2 + 20
    case .medium, .large:
      break
    }
    return systemImageSize + fontSizeWidth + 20
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 12)
      .foregroundColor(backgroundColor)
      .frame(minWidth: rectangleWidth, minHeight: 25)
      .overlay {
        VStack(alignment: .center) {
          HStack(spacing: 3) {
            if let systemImage = option.systemImage {
              Image(systemName: systemImage)
                .imageScale(.small)
                .foregroundColor(.white)
            }

            Text(option.title)
              .foregroundColor(.white)
              .font(Font(CTFont(.smallToolbar, size: 10)))
          }
          .fixedSize()
        }
      }
      .fixedSize()
  }
}

#Preview {
  IconPill(option: IconPillOption(title: "1x / week", systemImage: "clock"))
    .previewLayout(.sizeThatFits)
}
