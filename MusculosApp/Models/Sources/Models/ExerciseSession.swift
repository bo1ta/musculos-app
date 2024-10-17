//
//  ExerciseSession.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.06.2024.
//

import Foundation
import Utility

public struct ExerciseSession: Codable, Sendable {
  public let dateAdded: Date
  public let sessionId: UUID
  public let user: UserProfile
  public let exercise: Exercise
  public let duration: Double

  public init(dateAdded: Date = Date(), sessionId: UUID, user: UserProfile, exercise: Exercise, duration: Double = 0) {
    self.dateAdded = dateAdded
    self.sessionId = sessionId
    self.user = user
    self.exercise = exercise
    self.duration = duration
  }
}

extension ExerciseSession: DecodableModel {}
