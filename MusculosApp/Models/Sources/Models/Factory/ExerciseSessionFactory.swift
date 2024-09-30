//
//  ExerciseSessionFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation

public struct ExerciseSessionFactory {
  public struct Default {
    public static let dateAdded = Date()
    public static let sessionID = UUID()

    public static let profile = UserProfileFactory.createProfile()
    public static let exercise = ExerciseFactory.createExercise()
  }

  public static func createExerciseSession(
    dateAdded: Date = Default.dateAdded,
    sessionID: UUID = Default.sessionID,
    profile: UserProfile = Default.profile,
    exercise: Exercise = Default.exercise
  ) -> ExerciseSession {
    return ExerciseSession(
      dateAdded: dateAdded,
      sessionId: sessionID,
      user: profile,
      exercise: exercise
    )
  }
}
