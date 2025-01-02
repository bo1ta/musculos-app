//
//  ExerciseSessionRepositoryStub.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Foundation
import Models
import Utility

public actor ExerciseSessionRepositoryStub: ExerciseSessionRepositoryProtocol {
  var expectedSessions: [ExerciseSession]
  var expectedExercises: [Exercise]
  var expectedUserExperienceEntry: UserExperienceEntry?

  public init(
    expectedSessions: [ExerciseSession] = [],
    expectedExercises: [Exercise] = [],
    expectedUserExperienceEntry: UserExperienceEntry? = nil)
  {
    self.expectedSessions = expectedSessions
    self.expectedExercises = expectedExercises
    self.expectedUserExperienceEntry = expectedUserExperienceEntry
  }

  public func getExerciseSessions() async throws -> [ExerciseSession] {
    expectedSessions
  }

  public func getRecommendationsForLeastWorkedMuscles() async throws -> [Exercise] {
    expectedExercises
  }

  public func getCompletedSinceLastWeek() async throws -> [ExerciseSession] {
    expectedSessions
  }

  public func getCompletedToday() async throws -> [ExerciseSession] {
    expectedSessions
  }

  public func addSession(_: ExerciseSession) async throws -> UserExperienceEntry {
    if let expectedUserExperienceEntry {
      return expectedUserExperienceEntry
    }
    throw MusculosError.unexpectedNil
  }
}
