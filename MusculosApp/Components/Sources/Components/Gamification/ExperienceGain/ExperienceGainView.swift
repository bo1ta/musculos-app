//
//  XPGainView.swift
//  Components
//
//  Created by Solomon Alexandru on 21.12.2024.
//

import SwiftUI
import Utility

public struct XPGainView: View {
  @State private var isAnimating = false

  let xpGained: Int

  public init(_ xpGained: Int) {
    self.xpGained = xpGained
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 16)
      .fill(gradient)
      .frame(width: 100, height: 40)
      .overlay {
        RoundedRectangle(cornerRadius: 16)
          .stroke(.white.opacity(0.5), lineWidth: 1)
          .blur(radius: 1)
          .frame(width: 100, height: 40)
      }
      .padding()
      .overlay(
        Text("+ \(xpGained) XP")
          .foregroundStyle(.white)
          .font(AppFont.poppins(.bold, size: 18))
          .shadow(color: .black.opacity(0.2), radius: 2)
      )
      .shadow(color: .purple.opacity(0.5), radius: 8)
      .scaleEffect(isAnimating ? 1.1 : 1.0)
      .opacity(isAnimating ? 1 : 0.8)
      .animation(
        .spring(response: 0.3, dampingFraction: 0.6).repeatCount(1),
        value: isAnimating
      )
      .onAppear {
        isAnimating = true
      }
  }

  private var gradient: LinearGradient {
    LinearGradient(
      colors: [
        AppColor.darkPurple,
        AppColor.darkPurple.opacity(0.7),
        AppColor.darkPurple.opacity(0.2),
      ],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }
}

#Preview {
  XPGainView(100)
}
