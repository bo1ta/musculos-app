//
//  ExerciseFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Foundation
import Models

public class ExerciseFactory: BaseFactory, @unchecked Sendable {
  typealias Constants = ExerciseConstants

  public var id: UUID?
  public var category: String?
  public var equipment: String?
  public var force: String?
  public var level: String?
  public var name: String?
  public var primaryMuscles: [String]?
  public var secondaryMuscles: [String]?
  public var instructions: [String]?
  public var imageUrls: [String]?
  public var isFavorite: Bool?

  public func create() -> Exercise {
    let exercise = Exercise(
      category: category ?? Constants.CategoryType.cardio.rawValue,
      equipment: equipment ?? Constants.EquipmentType.bands.rawValue,
      force: force ?? Constants.ForceType.pull.rawValue,
      id: id ?? UUID(),
      level: level ?? Constants.LevelType.beginner.rawValue,
      name: name ?? "3/4 Sit-ups",
      primaryMuscles: primaryMuscles ?? [MuscleType.lowerBack.rawValue],
      secondaryMuscles: secondaryMuscles ?? [MuscleType.biceps.rawValue],
      instructions: instructions ?? ["Step 1", "Step 2"],
      imageUrls: imageUrls ?? [faker.internet.url()],
      isFavorite: isFavorite ?? false)
    syncObject(exercise, of: ExerciseEntity.self)
    return exercise
  }

  public static func createExercise(isFavorite: Bool = false) -> Exercise {
    let factory = ExerciseFactory()
    factory.isFavorite = isFavorite
    return factory.create()
  }
}
