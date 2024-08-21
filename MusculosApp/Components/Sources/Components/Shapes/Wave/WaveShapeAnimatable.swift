//
//  WaveShapeAnimatable.swift
//  
//
//  Created by Solomon Alexandru on 31.07.2024.
//

import Foundation
import SwiftUI

public struct WaveShapeAnimatable: Shape, Animatable {
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
    let bottomPadding: CGFloat = height * 0.13
    
    let waveHeight = calculateWaveHeight(rectHeight: height)
    
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: width, y: 0))
    path.addLine(to: CGPoint(x: width, y: waveHeight))
    
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
  
  private func calculateWaveHeight(rectHeight: Double) -> Double {
    let minWaveHeight = rectHeight * 0.75
    let maxWaveHeight = rectHeight * 0.95
    
    return minWaveHeight + (maxWaveHeight - minWaveHeight) * waveSize
  }
}
