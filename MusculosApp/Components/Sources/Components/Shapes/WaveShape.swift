//
//  WaveShape.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.03.2024.
//

import SwiftUI

public struct WaveShape: Shape {
  public init() {}

  public func path(in rect: CGRect) -> Path {
    return Path { path in
      path.move(to: CGPoint(x: rect.minX, y: rect.midY - 100))

      path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY + 50), control: CGPoint(x: rect.width * 0.40, y: rect.height * 0.67))

      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    }
  }
}
