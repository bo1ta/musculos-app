//
//  Constants.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.06.2023.
//

import Foundation

public enum HTTPMethod: String {
  case get  = "GET"
  case post   = "POST"
  case put  = "PUT"
  case delete = "DELETE"
}

public class HTTPHeaderConstants: NSObject {
  static let contentType = "Content-Type"
  static let authorization = "Authorization"
}

public class UIConstants: NSObject {
  static let componentOpacity: Double = 0.95
}

public enum UserDefaultsKey: String {
  case isAuthenticated = "is_authenticated"
  case authToken = "auth_token"
  case isOnboarded = "is_onboarded"
}

enum MuscleType: String {
    case abdominals
    case hamstrings
    case adductors
    case quadriceps
    case biceps
    case shoulders
    case chest
    case middleBack = "middle back"
    case calves
    case glutes
    case lowerBack = "lower back"
    case lats
    case triceps
    case traps
    case forearms
    case neck
    case abductors
}
extension MuscleType: CaseIterable {}

enum ForceType: String {
    case pull
    case push
    case `static`
}
extension ForceType: CaseIterable {}

enum LevelType: String {
    case beginner
    case intermediate
    case expert
}
extension LevelType: CaseIterable {}

enum MechanicType: String {
    case compound
    case isolation
}
extension MechanicType: CaseIterable {}

enum EquipmentType: String {
    case bodyOnly = "body only"
    case machine
    case other
    case foamRoll = "foam roll"
    case kettlebells
    case dumbbell
    case cable
    case barbell
    case bands
    case medicineBall = "medicine ball"
    case exerciseBall = "exercise ball"
    case ezCurlBar = "e-z curl bar"
}
extension EquipmentType: CaseIterable {}

enum CategoryType: String {
    case strength
    case stretching
    case plyometrics
    case strongman
    case powerlifting
    case cardio
    case olympicWeightlifting = "olympic weightlifting"
}
extension CategoryType: CaseIterable {}
