//
//  ExerciseFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.03.2024.
//

import Foundation

struct ExerciseFactory {
  public var category: String?
  public var equipment: String?
  public var force: String?
  public var level: String?
  public var name: String?
  public var primaryMuscles: [String] = []
  public var secondaryMuscles: [String] = []
  public var instructions: [String] = []
  public var imageUrls: [String] = []
  
  func create() -> Exercise {
    Exercise(category: category ?? "home workout",
             id: UUID(),
             level: level ?? "beginner",
             name: name ?? "3/4 Sit-ups",
             primaryMuscles: primaryMuscles.count > 0 ? primaryMuscles : ["legs", "abs"],
             secondaryMuscles: secondaryMuscles.count > 0 ? secondaryMuscles : ["back"],
             instructions: instructions.count > 0 ? instructions : ["Instruction 1", "Instruction 2", "Instruction 3"],
             imageUrls: imageUrls)
  }
  
  static func createExercise(
    name: String = "Power Stairs",
    primaryMuscles: [String] = ["hamstrings"],
    secondaryMuscles: [String] = ["calves", "glutes", "traps"],
    equipment: String = "barbell",
    category: String = "powerlifting",
    force: String = "pull",
    level: String = "intermediate",
    instructions: [String] =
    [
      "In the power stairs, implements are moved up a staircase. For training purposes, these can be performed with a tire or box.",
      "Begin by taking the implement with both hands. Set your feet wide, with your head and chest up. Drive through the ground with your heels, extending your knees and hips to raise the weight from the ground.",
      "As you lean back, attempt to swing the weight onto the stairs, which are usually around 16-18\" high. You can use your legs to help push the weight onto the stair.",
      "Repeat for 3-5 repetitions, and continue with a heavier weight, moving as fast as possible."
    ]
  ) -> Exercise {
    Exercise(category: category, id: UUID(), level: level, name: name, primaryMuscles: primaryMuscles, secondaryMuscles: secondaryMuscles, instructions: instructions, imageUrls: [])
  }
}
