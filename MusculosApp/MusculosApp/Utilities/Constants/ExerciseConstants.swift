//
//  ExerciseConstant.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import Foundation

public struct ExerciseConstants {
  enum MuscleType: String, CaseIterable, Identifiable {
    case abdominals, hamstrings, adductors, quadriceps, biceps, shoulders, chest, calves, glutes, lats, triceps, traps, forearms, neck, abductors
    case middleBack = "middle back"
    case lowerBack = "lower back"
    
    var id: Int {
      switch self {
      case .abdominals: 0
      case .hamstrings: 1
      case .adductors: 2
      case .quadriceps: 3
      case .biceps: 4
      case .shoulders: 5
      case .chest: 6
      case .calves: 7
      case .glutes: 8
      case .lats: 9
      case .triceps: 10
      case .traps: 11
      case .forearms: 12
      case .neck: 13
      case .abductors: 14
      case .middleBack: 15
      case .lowerBack: 16
      }
    }
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

