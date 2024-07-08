//
//  String+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.07.2023.
//

import Foundation
import UIKit

extension String {
  func widthOfString(usingFont font: UIFont) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = self.size(withAttributes: fontAttributes)
    return size.width
  }
}
