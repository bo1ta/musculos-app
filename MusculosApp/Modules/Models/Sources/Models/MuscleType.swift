//
//  MuscleType.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.05.2024.
//

import Foundation

// MARK: - MuscleType

public enum MuscleType: String, CaseIterable, Identifiable, Sendable {
  case abdominals, hamstrings, adductors, quadriceps, biceps, shoulders, chest, calves, glutes, lats, triceps, traps, forearms,
       neck, abductors
  case middleBack = "middle back"
  case lowerBack = "lower back"

  public var id: Int {
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

// MARK: - MuscleGroup

public struct MuscleGroup: Hashable, Sendable {
  public let name: String
  public let muscles: [MuscleType]

  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(muscles.map(\.id))
  }
}
