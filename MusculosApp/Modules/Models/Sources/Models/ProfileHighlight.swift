//
//  ProfileHighlight.swift
//  Models
//
//  Created by Solomon Alexandru on 04.10.2024.
//

import Foundation

public struct ProfileHighlight: Hashable {
  public let highlightType: ProfileHighlightType
  public let value: String
  public let description: String

  public init(highlightType: ProfileHighlightType, value: String, description: String) {
    self.highlightType = highlightType
    self.value = value
    self.description = description
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(highlightType.title)
    hasher.combine(value)
    hasher.combine(description)
  }
}
