//
//  APIEndpoint.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation

enum Endpoint: CustomStringConvertible {
  case authentication
  case register
  case persons
  case questions
  case userAnswers
  case muscle
  case equipment
  case exercise
  case searchExercise(name: String)
  case exercisesByMuscle(name: String)

  var description: String {
    switch self {
    case .authentication:
      return "/user/login"
    case .register:
      return "/user/register"
    case .persons:
      return "/persons"
    case .questions:
      return "/api/questions"
    case .userAnswers:
      return "/user-answers"
    case .muscle:
      return "/muscle"
    case .equipment:
      return "/equipment"
    case .exercise:
      return "/exercises"
    case let .searchExercise(name):
      return "/exercises/name/\(name)"
    case let .exercisesByMuscle(name):
      return "/exercises/bodyPart/\(name)"
    }
  }
}

public class APIEndpoint {
  static let base = "https://exercisedb.p.rapidapi.com"

  static func baseWithEndpoint(endpoint: Endpoint) -> String {
    return Self.base + endpoint.description
  }
}
