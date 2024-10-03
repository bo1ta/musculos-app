//
//  IconPillOption.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import Foundation

public struct IconPillOption {
  var title: String
  var systemImage: String?

  public init(title: String, systemImage: String? = nil) {
    self.title = title
    self.systemImage = systemImage
  }
}

extension IconPillOption: Hashable {
  public static func == (lhs: IconPillOption, rhs: IconPillOption) -> Bool {
    return lhs.title == rhs.title
  }
}
