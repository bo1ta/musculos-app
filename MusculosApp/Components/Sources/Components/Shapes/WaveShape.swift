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

public struct TopWaveShape: Shape, Animatable {
  private var waveSize: Double
  private var horizontalOffset: Double

  public var animatableData: AnimatablePair<Double, Double> {
    get {
      AnimatablePair(waveSize, horizontalOffset)
    }
    set {
      waveSize = newValue.first
      horizontalOffset = newValue.second
    }
  }

  public init(waveSize: Double = 0.6, horizontalOffset: Double = 0) {
    self.waveSize = waveSize
    self.horizontalOffset = horizontalOffset
  }

  public func path(in rect: CGRect) -> Path {
    var path = Path()
    let width = rect.size.width
    let height = rect.size.height

    // Adjust these values to control the wave's range of motion
    let minWaveHeight = height * 0.75 // Covers 3/4 of the screen at minimum
    let maxWaveHeight = height * 0.95 // Almost full screen at maximum
    let waveHeight = minWaveHeight + (maxWaveHeight - minWaveHeight) * waveSize

    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: width, y: 0))
    path.addLine(to: CGPoint(x: width, y: waveHeight))

    // Adjust control points based on horizontalOffset
    let control1X = width * (0.75 - 0.5 * horizontalOffset)
    let control2X = width * (0.25 - 0.5 * horizontalOffset)
    let controlY1 = waveHeight - (height * 0.1 * (1 + waveSize))
    let controlY2 = waveHeight + (height * 0.1 * (1 - waveSize))

    path.addCurve(
      to: CGPoint(x: 0, y: waveHeight),
      control1: CGPoint(x: control1X, y: controlY1),
      control2: CGPoint(x: control2X, y: controlY2)
    )

    path.closeSubpath()
    return path
  }
}
