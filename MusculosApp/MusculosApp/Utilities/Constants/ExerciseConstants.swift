//
//  ExerciseConstant.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import Foundation

public struct ExerciseConstants {
  enum MuscleType: String, CaseIterable {
    case abdominals, hamstrings, adductors, quadriceps, biceps, shoulders, chest, calves, glutes, lats, triceps, traps, forearms, neck, abductors
    case middleBack = "middle back"
    case lowerBack = "lower back"
  }
  
  enum ForceType: String, CaseIterable {
    case pull, push, `static`
  }
  
  enum LevelType: String, CaseIterable {
    case beginner, intermediate, expert
  }
  
  enum MechanicType: String, CaseIterable {
    case compound, isolation
  }
  
  enum EquipmentType: String, CaseIterable {
    case machine, other, kettlebells, dumbbell, cable, barbell, bands
    case bodyOnly = "body only"
    case foamRoll = "foam roll"
    case medicineBall = "medicine ball"
    case exerciseBall = "exercise ball"
    case ezCurlBar = "e-z curl bar"
  }
  
  enum CategoryType: String, CaseIterable {
    case strength, stretching, plyometrics, strongman, powerlifting, cardio
    case olympicWeightlifting = "olympic weightlifting"
  }
  
  /// All cases lists -- perfect for filters!
  ///
  static let muscleOptions = MuscleType.allCases.map { $0.rawValue }
  static let forceOptions = ForceType.allCases.map { $0.rawValue }
  static let levelOptions = LevelType.allCases.map { $0.rawValue }
  static let equipmentOptions = EquipmentType.allCases.map { $0.rawValue }
  static let categoryOptions = CategoryType.allCases.map { $0.rawValue }
}
