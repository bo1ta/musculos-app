//
//  ExerciseSessionFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation

public struct ExerciseSessionFactory {
  public static func createExerciseSession() -> ExerciseSession {
    let person = UserProfileFactory.createProfile()
    let exercise = ExerciseFactory.createExercise()
    return ExerciseSession(dateAdded: Date(), sessionId: UUID(), user: person, exercise: exercise)
  }
}
