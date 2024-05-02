//
//  OnboardingGoal.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI

enum OnboardingGoal: Int {
  case loseWeight, getFitter, gainMuscles

  var title: String {
    switch self {
    case .loseWeight: "Lose weight"
    case .getFitter: "Get fitter"
    case .gainMuscles: "Gain muscles"
    }
  }
  
  var description: String {
    switch self {
    case .loseWeight: "Burn fat & get lean"
    case .getFitter: "Tone up & feel healthy"
    case .gainMuscles: "Build mass & strength"
    }
  }
  
  var image: Image {
    switch self {
    case .loseWeight: Image(systemName: "flame")
    case .getFitter: Image(systemName: "bolt.heart")
    case .gainMuscles: Image(systemName: "dumbbell")
    }
  }
}
