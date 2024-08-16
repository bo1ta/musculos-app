//
//  WaveShape.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.03.2024.
//

import SwiftUI

public struct WaveShape: Shape {
  var waveHeight: CGFloat = 50
  var controlPointYOffset: CGFloat = 30

  public init() {
    
  }

  public func path(in rect: CGRect) -> Path {
    var path = Path()
    
    // Start from the top-left corner
    path.move(to: CGPoint(x: 0, y: rect.height * 0.75))
    
    // First control point (left wave peak)
    let controlPoint1 = CGPoint(x: rect.width * 0.25, y: rect.height * 0.75 + controlPointYOffset)
    let endPoint1 = CGPoint(x: rect.width * 0.5, y: rect.height * 0.75)
    
    // Second control point (right wave peak)
    let controlPoint2 = CGPoint(x: rect.width * 0.75, y: rect.height * 0.75 - controlPointYOffset)
    let endPoint2 = CGPoint(x: rect.width, y: rect.height * 0.75)
    
    // Draw the curves
    path.addCurve(to: endPoint1, control1: controlPoint1, control2: CGPoint(x: rect.width * 0.35, y: rect.height * 0.75 + waveHeight))
    path.addCurve(to: endPoint2, control1: CGPoint(x: rect.width * 0.65, y: rect.height * 0.75 - waveHeight), control2: controlPoint2)
    
    // Close the path (from the right down to the bottom and back to the left)
    path.addLine(to: CGPoint(x: rect.width, y: rect.height))
    path.addLine(to: CGPoint(x: 0, y: rect.height))
    path.closeSubpath()
    
    return path
  }
}
