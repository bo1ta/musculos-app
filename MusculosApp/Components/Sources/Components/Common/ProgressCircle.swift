//
//  ProgressCircle.swift
//  Components
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import SwiftUI
import Utility

public struct ProgressCircle: View {
  let progress: Double
  let circleSize: CGFloat

  public init(progress: Double, circleSize: CGFloat = 70) {
    self.progress = progress
    self.circleSize = circleSize
  }

  private let gradient = Gradient(colors: [
    .yellow,
    .orange,
    .red.opacity(0.7),
  ])

  public var body: some View {
    ZStack {
      Circle()
        .stroke(.white.opacity(0.05), lineWidth: 10)
        .frame(width: circleSize, height: circleSize)

      Circle()
        .trim(from: 0, to: CGFloat(progress))
        .stroke(gradient, lineWidth: 10)
        .frame(width: circleSize, height: circleSize)
        .rotationEffect(Angle(degrees: -90))

      Text("\(Int(progress * 100))%")
        .font(AppFont.poppins(.bold, size: 15))
        .foregroundStyle(.white)
    }
  }
}

#Preview {
  ProgressCircle(progress: 0.4)
}
