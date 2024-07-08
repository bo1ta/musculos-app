//
//  ExerciseSessionFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation

struct ExerciseSessionFactory {
  static func createExerciseSession() -> ExerciseSession {
    let person = PersonFactory.createPerson()
    let exercise = ExerciseFactory.createExercise()
    return ExerciseSession(date: Date(), sessionId: UUID(), user: person, exercise: exercise)
  }
}
