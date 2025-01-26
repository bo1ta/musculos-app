//
//  UIImage+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.10.2023.
//

import Foundation
import SwiftUI

extension UIImage {
  static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage? {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    gradientLayer.colors = colors

    UIGraphicsBeginImageContext(gradientLayer.bounds.size)
    defer { UIGraphicsEndImageContext() }

    if let currentContext = UIGraphicsGetCurrentContext() {
      gradientLayer.render(in: currentContext)
    }

    return UIGraphicsGetImageFromCurrentImageContext()
  }

  func resized(to newSize: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    defer { UIGraphicsEndImageContext() }

    draw(in: CGRect(origin: .zero, size: newSize))
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}
