//
//  ProgressEntry.swift
//  Models
//
//  Created by Solomon Alexandru on 26.09.2024.
//

import Foundation
import Utility

// MARK: - ProgressEntry

public struct ProgressEntry: Codable, Sendable {
  public let id: UUID
  public let dateAdded: Date
  public let value: Double
  public let goal: Goal

  public init(id: UUID = UUID(), dateAdded: Date, value: Double, goal: Goal) {
    self.id = id
    self.dateAdded = dateAdded
    self.value = value
    self.goal = goal
  }

  enum CodingKeys: String, CodingKey {
    case id = "progressID"
    case dateAdded
    case value
    case goal
  }
}

// MARK: Hashable

extension ProgressEntry: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(dateAdded)
    hasher.combine(value)
  }
}

// MARK: DecodableModel

extension ProgressEntry: DecodableModel { }

// MARK: IdentifiableEntity

extension ProgressEntry: IdentifiableEntity { }
