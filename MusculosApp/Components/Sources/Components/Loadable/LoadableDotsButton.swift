//
//  LoadableDotsButton.swift
//
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import SwiftUI
import Utility

public struct LoadableDotsButton: View {
  private let title: String
  private let dotsColor: Color
  private let animationDuration: Double
  private let action: () -> Void

  @Binding private var isLoading: Bool

  public init(
    title: String,
    dotsColor: Color = .white,
    animationDuration: Double = 0.6,
    isLoading: Binding<Bool>,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.dotsColor = dotsColor
    self.animationDuration = animationDuration
    self.action = action
    self._isLoading = isLoading
  }

    public var body: some View {
      Button(action: action, label: {
        ZStack {
          if isLoading {
            // mirror the text from the else statement, but with 0 opacity, to preserve the button's height
            Text(title)
              .font(Font.body(.bold, size: 17))
              .frame(maxWidth: .infinity)
              .foregroundStyle(.white)
              .shadow(radius: 2)
              .shadow(color: .black.opacity(0.5), radius: 1)
              .opacity(0)

            LoadingDotsView(dotsColor: dotsColor, animationDuration: animationDuration)
              .frame(maxWidth: .infinity)
          } else {
            Text(title)
              .font(Font.body(.bold, size: 17))
              .frame(maxWidth: .infinity)
              .foregroundStyle(.white)
              .shadow(radius: 2)
              .shadow(color: .black.opacity(0.5), radius: 1)
          }
        }
        })
        .buttonStyle(PrimaryButtonStyle())
        .disabled(isLoading)
    }
}

#Preview {
  LoadableDotsButton(title: "Click me", isLoading: .constant(false), action: {})
}
