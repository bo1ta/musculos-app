//
//  ProgressEntry.swift
//  Models
//
//  Created by Solomon Alexandru on 26.09.2024.
//

import Foundation

public struct ProgressEntry: Codable, Sendable {
  public let progressID: UUID
  public let dateAdded: Date
  public let value: Double
  public let goal: Goal

  public init(progressID: UUID = UUID(), dateAdded: Date, value: Double, goal: Goal) {
    self.progressID = progressID
    self.dateAdded = dateAdded
    self.value = value
    self.goal = goal
  }
}

extension ProgressEntry: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(progressID)
    hasher.combine(dateAdded)
    hasher.combine(value)
  }
}
