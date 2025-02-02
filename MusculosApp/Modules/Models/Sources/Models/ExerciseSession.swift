//
//  ExerciseSession.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.06.2024.
//

import Foundation
import Utility

// MARK: - ExerciseSession

public struct ExerciseSession: Codable, Sendable {
  public let dateAdded: Date
  public let id: UUID
  public let user: UserProfile
  public let exercise: Exercise
  public let duration: Double
  public var weight: Double?

  public init(
    dateAdded: Date = Date(),
    id: UUID = UUID(),
    user: UserProfile,
    exercise: Exercise,
    duration: Double = 0,
    weight: Double = 0)
  {
    self.dateAdded = dateAdded
    self.id = id
    self.user = user
    self.exercise = exercise
    self.duration = duration
    self.weight = weight
  }

  enum CodingKeys: String, CodingKey {
    case dateAdded
    case id = "sessionId"
    case user
    case exercise
    case duration
    case weight
  }
}

// MARK: Hashable

extension ExerciseSession: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  public static func ==(_ lhs: ExerciseSession, rhs: ExerciseSession) -> Bool {
    lhs.id == rhs.id
  }
}

// MARK: DecodableModel

extension ExerciseSession: DecodableModel { }

// MARK: IdentifiableEntity

extension ExerciseSession: IdentifiableEntity { }
