//
//  ExerciseSession.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.06.2024.
//

import Foundation

struct ExerciseSession: Codable {
  let date: Date
  let sessionId: UUID
  let user: Person
  let exercise: Exercise
}

extension ExerciseSession: Recommendable {}
