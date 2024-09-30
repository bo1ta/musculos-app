//
//  ExerciseFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.03.2024.
//

import Foundation

public struct ExerciseFactory {
  public struct Default {
    public static let category = "home workout"
    public static let equipment = "bodyweight"
    public static let force = "push"
    public static let level = "beginner"
    public static let name = "3/4 Sit-ups"
    public static let primaryMuscles = ["legs", "abs"]
    public static let secondaryMuscles = ["back"]
    public static let instructions = ["Instruction 1", "Instruction 2", "Instruction 3"]
    public static let imageUrls: [String] = []
    public static let isFavorite = false
  }

  public static func createExercise(
    id: UUID = UUID(),
    category: String = Default.category,
    equipment: String = Default.equipment,
    force: String = Default.force,
    level: String = Default.level,
    name: String = Default.name,
    primaryMuscles: [String] = Default.primaryMuscles,
    secondaryMuscles: [String] = Default.secondaryMuscles,
    instructions: [String] = Default.instructions,
    imageUrls: [String] = Default.imageUrls,
    isFavorite: Bool = Default.isFavorite
  ) -> Exercise {
    return Exercise(
      category: category,
      equipment: equipment,
      force: force,
      id: id,
      level: level,
      name: name,
      primaryMuscles: primaryMuscles,
      secondaryMuscles: secondaryMuscles,
      instructions: instructions,
      imageUrls: imageUrls,
      isFavorite: isFavorite
    )
  }
}
