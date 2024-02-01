//
//  Goal.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import Foundation

enum Goal {
  case loseWeight, getFitter, gainMuscles

  var title: String {
    switch self {
    case .loseWeight:
      "Lose weight"
    case .getFitter:
      "Get fitter"
    case .gainMuscles:
      "Gain muscles"
    }
  }
  
  var description: String {
    switch self {
    case .loseWeight:
      "Burn fat & get lean"
    case .getFitter:
      "Tone up & feel healthy"
    case .gainMuscles:
      "Build mass & strength"
    }
  }
  
  var imageName: String {
    switch self {
    case .loseWeight:
      "icon-fire"
    case .getFitter:
      "icon-heartbeat"
    case .gainMuscles:
      "icon-dumbbell"
    }
  }
}
