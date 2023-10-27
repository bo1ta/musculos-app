//
//  Challenge.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.10.2023.
//

import Foundation

struct Challenge {
  let name: String
  let exercises: [ChallengeExercise]
}

struct ChallengeExercise {
  let name: String
  let image: String
  let instructions: String?
  let rounds: Int
  let duration: Int
  let restDuration: Int
  
  init(name: String, image: String, instructions: String? = nil, rounds: Int, duration: Int, restDuration: Int) {
    self.name = name
    self.image = image
    self.instructions = instructions
    self.rounds = rounds
    self.duration = duration
    self.restDuration = restDuration
  }
}

extension ChallengeExercise: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(rounds)
  }

  static func ==(lhs: ChallengeExercise, rhs: ChallengeExercise) -> Bool {
    return lhs.name == rhs.name
  }
}
