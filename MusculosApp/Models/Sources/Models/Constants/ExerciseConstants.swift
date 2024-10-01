//
//  ExerciseConstant.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import Foundation
import SwiftUI

public struct ExerciseConstants {
  public enum ForceType: String, CaseIterable {
    case pull, push, `static`
  }
  
  public enum LevelType: String, CaseIterable {
    case beginner, intermediate, expert
  }
  
  public enum MechanicType: String, CaseIterable {
    case compound, isolation
  }
  
  public enum EquipmentType: String, CaseIterable {
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

    public var imageName: String {
      switch self {
      case .dumbbell: "health-dumbbell"
      case .barbell: "health-barbell"
      default: "health-sheet"
      }
    }

    public var color: Color {
      switch self {
      case .dumbbell: .blue
      case .barbell: .green
      default: .orange
      }
    }

    public var title: String {
      switch self {
      case .dumbbell: "Dumbbells"
      case .barbell: "Barbells"
      case .bands: "Bands"
      case .bodyOnly: "Body Only"
      case .cable: "Cable"
      case .exerciseBall: "Exercise Ball"
      case .ezCurlBar: "E-Z Curl Bar"
      case .medicineBall: "Medicine Ball"
      case .kettlebells: "Kettlebells"
      case .other: "Other"
      case .machine: "Machine"
      case .foamRoll: "Foam Roll"
      }
    }
  }
  
  public enum CategoryType: String, CaseIterable {
    case strength
    case stretching
    case plyometrics
    case strongman
    case powerlifting
    case cardio
    case olympicWeightlifting = "olympic weightlifting"
    
    public var imageName: String {
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
  public static let muscleOptions = MuscleType.allCases.map { $0.rawValue }
  public static let forceOptions = ForceType.allCases.map { $0.rawValue }
  public static let levelOptions = LevelType.allCases.map { $0.rawValue }
  public static let equipmentOptions = EquipmentType.allCases.map { $0.rawValue }
  public static let categoryOptions = CategoryType.allCases.map { $0.rawValue }
}
