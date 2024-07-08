//
//  ExerciseSession.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.06.2024.
//

import Foundation

public struct ExerciseSession: Codable {
  public let date: Date
  public let sessionId: UUID
  public let user: User
  public let exercise: Exercise
  
  public init(date: Date, sessionId: UUID, user: User, exercise: Exercise) {
    self.date = date
    self.sessionId = sessionId
    self.user = user
    self.exercise = exercise
  }
}
