//
//  AnimatedScreenBordersModifier.swift
//  Utility
//
//  Created by Solomon Alexandru on 09.10.2024.
//

import SwiftUI

// MARK: - AnimatedScreenBordersModifier

public struct AnimatedScreenBordersModifier: ViewModifier {
  let isActive: Bool
  let borderHeight: CGFloat

  public init(isActive: Bool, borderHeight: CGFloat = 14.0) {
    self.isActive = isActive
    self.borderHeight = borderHeight
  }

  public func body(content: Content) -> some View {
    content
      .overlay {
        if isActive {
          BorderAnimationContainer(borderHeight: borderHeight)
        }
      }
  }
}

// MARK: - BorderAnimationContainer

private struct BorderAnimationContainer: View {
  @State private var dimOpacity: CGFloat = 0.0
  let borderHeight: CGFloat

  var body: some View {
    GeometryReader { geometry in
      OptimizedBorderAnimation(size: geometry.size, borderHeight: borderHeight)
        .opacity(dimOpacity)
    }
    .ignoresSafeArea()
    .onAppear {
      withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
        dimOpacity = 0.7
      }
    }
  }
}

// MARK: - OptimizedBorderAnimation

private struct OptimizedBorderAnimation: View {
  @State private var animationPhase: CGFloat = 0
  let size: CGSize
  let borderHeight: CGFloat

  private let gradient = LinearGradient(
    gradient: Gradient(colors: [.red, .red.opacity(0.9), .red.opacity(0.8)]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing)

  var body: some View {
    ZStack {
      // Top border
      DashedLine()
        .frame(width: size.width, height: 16)
        .position(x: size.width / 2, y: 8)

      // Right border
      DashedLine()
        .frame(width: size.height, height: 16)
        .rotationEffect(.degrees(90), anchor: .center)
        .position(x: size.width - 8, y: size.height / 2)

      // Bottom border
      DashedLine()
        .frame(width: size.width, height: 16)
        .position(x: size.width / 2, y: size.height - 8)

      // Left border
      DashedLine()
        .frame(width: size.height, height: 16)
        .rotationEffect(.degrees(90), anchor: .center)
        .position(x: 8, y: size.height / 2)
    }
    .blur(radius: 8)
  }
}

// MARK: - DashedLine

private struct DashedLine: View {
  @State private var animationPhase: CGFloat = 0

  var body: some View {
    Rectangle()
      .fill(.red)
      .mask(
        Rectangle()
          .stroke(
            style: StrokeStyle(
              lineWidth: 14,
              lineCap: .round,
              lineJoin: .round,
              dash: [30, 15],
              dashPhase: animationPhase)))
      .onAppear {
        withAnimation(.linear.repeatForever(autoreverses: false).speed(1)) {
          animationPhase -= 45
        }
      }
  }
}
