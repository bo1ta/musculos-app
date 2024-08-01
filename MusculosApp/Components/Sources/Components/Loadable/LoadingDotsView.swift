//
//  LoadingDotsView.swift
//
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import SwiftUI

public struct LoadingDotsView: View {
  @State private var currentDotIndex = 0
  @State private var timer: Timer?

  private let dotsColor: Color
  private let animationDuration: Double

  public init(dotsColor: Color, animationDuration: Double = 0.6) {
    self.dotsColor = dotsColor
    self.animationDuration = animationDuration
  }

  public var body: some View {
    HStack(spacing: 8) {
      ForEach(0..<3) { index in
        Circle()
          .fill(dotsColor)
          .frame(width: 10, height: 10)
          .scaleEffect(index == currentDotIndex ? 1.5 : 1.0)
          .animation(.easeInOut(duration: animationDuration), value: currentDotIndex)
      }
    }
    .onAppear {
      timer = Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
        currentDotIndex = (currentDotIndex + 1) % 3
      }
    }
    .onDisappear {
      timer?.invalidate()
      timer = nil
    }
  }
}

#Preview {
  LoadingDotsView(dotsColor: .white)
}
