//
//  File.swift
//  
//
//  Created by Solomon Alexandru on 16.08.2024.
//

import Foundation
import SwiftUI
import UIKit

public struct SineWaveAnimatableShape: Shape, Animatable {
  var phase: CGFloat
  var amplitude: CGFloat
  var frequency: CGFloat
  var offset: CGFloat

  public init(phase: CGFloat, amplitude: CGFloat, frequency: CGFloat, offset: CGFloat) {
    self.phase = phase
    self.amplitude = amplitude
    self.frequency = frequency
    self.offset = offset
  }

  public var animatableData: CGFloat {
    get { phase }
    set { phase = newValue }
  }

  public func path(in rect: CGRect) -> Path {
    var path = Path()
    let width = rect.width
    let height = rect.height
    let midHeight = height * (0.7 + 0.2 * offset)

    path.move(to: CGPoint(x: 0, y: midHeight))

    for x in stride(from: 0, through: width, by: 1) {
      let relativeX = x / width
      let y = midHeight + sin(relativeX * frequency * .pi * 2 + phase) * amplitude * height
      path.addLine(to: CGPoint(x: x, y: y))
    }

    path.addLine(to: CGPoint(x: width, y: height))
    path.addLine(to: CGPoint(x: 0, y: height))
    path.closeSubpath()

    return path
  }
}
