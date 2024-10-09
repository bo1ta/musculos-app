//
//  AnimatedScreenBordersModifier.swift
//  Utility
//
//  Created by Solomon Alexandru on 09.10.2024.
//

import SwiftUI

public struct AnimatedScreenBordersModifier: ViewModifier {
  @State private var animationPhase: CGFloat = 0
  @State private var dimOpacity: CGFloat = 0.0

  let isActive: Bool

  public init(isActive: Bool) {
    self.isActive = isActive
  }

  public func body(content: Content) -> some View {
    content
      .overlay {
        if isActive {
          GeometryReader { geometry in
            ZStack {
              FullScreenBorderAnimation(size: geometry.size)
                .opacity(dimOpacity)
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: dimOpacity)
            }
          }
          .ignoresSafeArea()
          .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
              dimOpacity = 0.7
            }
          }
        }
      }
  }

  struct FullScreenBorderAnimation: View {
    @State private var animationPhase: CGFloat = 0

    let size: CGSize

    var body: some View {
      Path { path in
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: size.height))
        path.closeSubpath()
      }
      .stroke(
        LinearGradient(
          gradient: Gradient(colors: [.red, .red.opacity(0.9), .red.opacity(0.8)]),
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        ),
        style: StrokeStyle(
          lineWidth: 16,
          lineCap: .round,
          lineJoin: .round,
          dash: [30, 15],
          dashPhase: animationPhase
        )
      )
      .blur(radius: 8)
      .onAppear {
        withAnimation(.linear.repeatForever(autoreverses: false).speed(0.1)) {
          animationPhase -= 45
        }
      }
    }
  }
}
