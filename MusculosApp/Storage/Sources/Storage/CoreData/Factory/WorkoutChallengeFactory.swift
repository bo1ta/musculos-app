//
//  WorkoutChallengeFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 20.01.2025.
//

import Foundation
import Models

public class WorkoutChallengeFactory: BaseFactory, @unchecked Sendable {
  public var isPersistent = true

  public var id: UUID?
  public var title: String?
  public var description: String?
  public var level: ChallengeLevel?
  public var durationInDays: Int?
  public var dailyWorkouts: [DailyWorkout]?
  public var currentDay: Int?
  public var startDate: Date?
  public var completionDate: Date?

  public init() { }

  public func create() -> WorkoutChallenge {
    let model = WorkoutChallenge(
      id: id ?? UUID(),
      title: title ?? faker.lorem.words(amount: 3),
      description: description ?? faker.lorem.paragraph(),
      level: level ?? ChallengeLevel.beginner,
      durationInDays: durationInDays ?? faker.number.randomInt(min: 0, max: 30),
      dailyWorkouts: dailyWorkouts ?? [DailyWorkoutFactory.createDailyWorkout()],
      currentDay: faker.number.randomInt(min: 0, max: 30),
      startDate: startDate,
      completionDate: completionDate)
    syncObject(model, of: dWorkoutChallengeEntity.self)
    return model
  }

  public static func createWorkoutChallenge() -> WorkoutChallenge {
    WorkoutChallengeFactory().create()
  }
}
