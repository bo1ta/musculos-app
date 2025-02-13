//
//  SineWaveAnimatableShape.swift
//
//
//  Created by Solomon Alexandru on 16.08.2024.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - SineWaveAnimatableShape

public struct SineWaveAnimatableShape: Shape, Animatable, @unchecked Sendable {
  var waveSize: CGFloat
  var phase: CGFloat
  var amplitude: CGFloat
  var frequency: CGFloat
  var offset: CGFloat
  var wavePosition: WavePosition

  public init(
    waveSize: CGFloat,
    phase: CGFloat,
    amplitude: CGFloat,
    frequency: CGFloat,
    offset: CGFloat,
    wavePosition: WavePosition = .top)
  {
    self.waveSize = waveSize
    self.phase = phase
    self.amplitude = amplitude
    self.frequency = frequency
    self.offset = offset
    self.wavePosition = wavePosition
  }

  public var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, CGFloat> {
    get {
      AnimatablePair(AnimatablePair(phase, amplitude), waveSize)
    }
    set {
      phase = newValue.first.first
      amplitude = newValue.first.second
      waveSize = newValue.second
    }
  }

  public func path(in rect: CGRect) -> Path {
    switch wavePosition {
    case .top:
      makePathAtTheTop(in: rect)
    case .bottom:
      makePathAtTheBottom(in: rect)
    }
  }

  // swiftlint:disable identifier_name

  private func makePathAtTheBottom(in rect: CGRect) -> Path {
    Path { path in
      let width = rect.width
      let height = rect.height
      let midHeight = calculateMidHeight(from: height)
      path.move(to: CGPoint(x: 0, y: midHeight))
      for x in stride(from: 0, through: width, by: 1) {
        let relativeX = x / width
        let y = midHeight + sin(relativeX * frequency * .pi * 2 + phase) * amplitude * height * waveSize
        path.addLine(to: CGPoint(x: x, y: y))
      }
      path.addLine(to: CGPoint(x: width, y: height))
      path.addLine(to: CGPoint(x: 0, y: height))
      path.closeSubpath()
    }
  }

  private func makePathAtTheTop(in rect: CGRect) -> Path {
    Path { path in
      let width = rect.width
      let height = rect.height
      let midHeight = calculateMidHeight(from: height)

      path.move(to: CGPoint(x: 0, y: 0))

      path.addLine(to: CGPoint(x: 0, y: midHeight))

      for x in stride(from: 0, through: width, by: 1) {
        let relativeX = x / width
        let y = midHeight + sin(relativeX * frequency * .pi * 2 + phase) * amplitude * height * waveSize
        path.addLine(to: CGPoint(x: x, y: y))
      }

      path.addLine(to: CGPoint(x: width, y: 0))
      path.closeSubpath()
    }
  }

  // swiftlint:enable identifier_name

  private func calculateMidHeight(from height: CGFloat) -> CGFloat {
    switch wavePosition {
    case .top:
      height * (waveSize / 2 + 0.2 * offset)
    case .bottom:
      height * (1 - waveSize / 2 + 0.2 * offset)
    }
  }
}

// MARK: SineWaveAnimatableShape.WavePosition

extension SineWaveAnimatableShape {
  public enum WavePosition {
    case top, bottom
  }
}
