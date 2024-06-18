//
//  OnboardingData.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.06.2024.
//

import Foundation
import SwiftUI

protocol OnboardingOption {
  var title: String { get }
  var description: String { get }
  var image: Image? { get }
}

struct OnboardingData {
  
  // MARK: - Level

  enum Level: OnboardingOption, CaseIterable {
    case beginner
    case intermmediate
    case advanced
    
    var title: String {
      switch self {
      case .beginner: "Beginner"
      case .intermmediate: "Intermmediate"
      case .advanced: "Advanced"
      }
    }
    
    var description: String {
      switch self {
      case .beginner: "Someone who is relatively new to regular exercise or has just started"
      case .intermmediate: "Someone who exercises regularly but might not have an advanced routine"
      case .advanced: "Someone who exercises consistently and has a well-established fitness routine"
      }
    }
    
    var image: Image? {
      return nil
    }
  }
  
  // MARK: - Equipment
  
  enum Equipment: OnboardingOption, CaseIterable {
    case none
    case dumbbells
    case gym
    
    var title: String {
      switch self {
      case .none: "None"
      case .dumbbells: "Dumbbells"
      case .gym: "Gym"
      }
    }
    
    var description: String {
      switch self {
      case .none: "No equipment. I prefer working out with my body weight"
      case .dumbbells: "I have a set of dumbbells"
      case .gym: "I have access to a gym that provides equipment"
      }
    }
    
    var image: Image? {
      switch self {
      case .none: Image(systemName: "figure.flexibility")
      case .dumbbells: Image(systemName: "dumbbell.fill")
      case .gym: Image(systemName: "gym.bag")
      }
    }
  }
  
  // MARK: - Goal
  
  enum Goal: OnboardingOption, CaseIterable {
    case loseWeight
    case getFitter
    case gainMuscles

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
    
    var image: Image? {
      switch self {
      case .loseWeight: Image(systemName: "flame")
      case .getFitter: Image(systemName: "bolt.heart")
      case .gainMuscles: Image(systemName: "dumbbell")
      }
    }
  }
}
