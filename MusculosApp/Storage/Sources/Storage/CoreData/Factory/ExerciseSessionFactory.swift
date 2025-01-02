//
//  ExerciseSessionFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Foundation
import Models

public class ExerciseSessionFactory: BaseFactory, @unchecked Sendable {
  public var dateAdded: Date?
  public var sessionId: UUID?
  public var user: UserProfile?
  public var exercise: Exercise?
  public var duration: Double?
  public var weight: Double?
  public var isPersistent: Bool = true

  public init() { }

  public func create() -> ExerciseSession {
    let model = ExerciseSession(
      dateAdded: dateAdded ?? Date(),
      sessionId: sessionId ?? UUID(),
      user: user ?? UserProfileFactory.createUser(),
      exercise: exercise ?? ExerciseFactory.createExercise(),
      duration: duration ?? faker.number.randomDouble(),
      weight: weight ?? faker.number.randomDouble())
    syncObject(model, of: ExerciseSessionEntity.self)
    return model
  }

  public static func createExerciseSession() -> ExerciseSession {
    ExerciseSessionFactory().create()
  }
}
