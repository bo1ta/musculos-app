//
//  Challenge.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.10.2023.
//

import Foundation
import Models

public struct Challenge {
  public let name: String
  public let exercises: [ChallengeExercise]
  public let participants: [User]?
  
  public init(name: String, exercises: [ChallengeExercise], participants: [User]? = nil) {
    self.name = name
    self.exercises = exercises
    self.participants = participants
  }
}

public struct ChallengeExercise {
  public let name: String
  public let image: String?
  public let instructions: String?
  public let rounds: Int
  public let duration: Int
  public let restDuration: Int
  
  public init(name: String, image: String? = nil, instructions: String? = nil, rounds: Int, duration: Int = 60, restDuration: Int = 30) {
    self.name = name
    self.image = image
    self.instructions = instructions
    self.rounds = rounds
    self.duration = duration
    self.restDuration = restDuration
  }
}

extension ChallengeExercise: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(rounds)
  }

  public static func ==(lhs: ChallengeExercise, rhs: ChallengeExercise) -> Bool {
    return lhs.name == rhs.name
  }
}
