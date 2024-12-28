//
//  LoadingButton.swift
//
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import SwiftUI
import Utility

public struct LoadingButton: View {
  private let title: String
  private let dotsColor: Color
  private let animationDuration: Double
  private let isDisabled: Bool
  private let action: () -> Void

  @Binding private var isLoading: Bool

  public init(
    title: String,
    dotsColor: Color = .white,
    animationDuration: Double = 0.6,
    isLoading: Binding<Bool>,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.dotsColor = dotsColor
    self.animationDuration = animationDuration
    self.action = action
    self.isDisabled = isDisabled
    _isLoading = isLoading
  }

  public var body: some View {
    Button(action: action, label: {
      ZStack {
        if isLoading {
          // mirror the text from the else statement, but with 0 opacity, to preserve the button's height
          Text(title)
            .font(AppFont.poppins(.medium, size: 17))
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .opacity(0)

          LoadingDotsView(dotsColor: dotsColor, animationDuration: animationDuration)
            .frame(maxWidth: .infinity)
        } else {
          Text(title)
            .font(AppFont.poppins(.medium, size: 17))
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .shadow(radius: 1)
        }
      }
    })
    .buttonStyle(PrimaryButtonStyle())
    .disabled(isLoading || isDisabled)
    .opacity(isDisabled ? 0.6 : 1.0)
  }
}

#Preview {
  LoadingButton(title: "Click me", isLoading: .constant(false), action: {})
}
