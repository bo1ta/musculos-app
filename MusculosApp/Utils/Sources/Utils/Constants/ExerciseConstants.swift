//
//  ExerciseConstant.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import Foundation

public struct ExerciseConstants {
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
    case machine
    case other
    case kettlebells
    case dumbbell
    case cable
    case barbell
    case bands
    case bodyOnly = "body only"
    case foamRoll = "foam roll"
    case medicineBall = "medicine ball"
    case exerciseBall = "exercise ball"
    case ezCurlBar = "e-z curl bar"
  }
  
  enum CategoryType: String, CaseIterable {
    case strength
    case stretching
    case plyometrics
    case strongman
    case powerlifting
    case cardio
    case olympicWeightlifting = "olympic weightlifting"
    
    var imageName: String {
      switch self {
      case .strength: "strength-icon"
      case .stretching: "stretching-icon"
      case .strongman: "strongman-icon"
      case .powerlifting: "powerlifting-icon"
      case .cardio: "cardio-icon"
      default: "default-exercise-icon"
      }
    }
  }
  
  /// All cases lists -- perfect for filters!
  ///
  static let muscleOptions = MuscleType.allCases.map { $0.rawValue }
  static let forceOptions = ForceType.allCases.map { $0.rawValue }
  static let levelOptions = LevelType.allCases.map { $0.rawValue }
  static let equipmentOptions = EquipmentType.allCases.map { $0.rawValue }
  static let categoryOptions = CategoryType.allCases.map { $0.rawValue }
}
