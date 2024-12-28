//
//  MuscleConstant.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.09.2023.
//

import Foundation

public enum MuscleConstant {
  public enum MuscleName: String, CaseIterable, Sendable {
    case back, cardio, chest, neck, shoulders, waist
    case lowerArms = "lower arms"
    case lowerLegs = "lower legs"
    case upperArms = "upper arms"
    case upperLegs = "upper legs"
  }

  public static let muscleGroups: [MuscleGroup] = [
    MuscleGroup(name: "back", muscles: [.middleBack, .lowerBack, .lats, .traps]),
    MuscleGroup(name: "legs", muscles: [.hamstrings, .adductors, .quadriceps, .calves, .abductors, .glutes]),
    MuscleGroup(name: "arms", muscles: [.biceps, .triceps, .forearms]),
    MuscleGroup(name: "shoulders", muscles: [.shoulders, .neck]),
    MuscleGroup(name: "chest", muscles: [.chest]),
    MuscleGroup(name: "core", muscles: [.abdominals]),
  ]

  public struct MuscleImageInfo: Hashable, Sendable {
    public let uuid = UUID()

    public let frontAnatomyIds: [Int]?
    public let backAnatomyIds: [Int]?

    public init(frontAnatomyIds: [Int]? = nil, backAnatomyIds: [Int]? = nil) {
      self.frontAnatomyIds = frontAnatomyIds
      self.backAnatomyIds = backAnatomyIds
    }

    public static func == (_ lhs: MuscleImageInfo, rhs: MuscleImageInfo) -> Bool {
      return lhs.uuid == rhs.uuid
    }
  }

  public static func parseMuscleString(_ muscle: String) -> String {
    if let muscleName = MuscleConstant.MuscleName(rawValue: muscle) {
      return muscleName.rawValue
    } else {
      return MuscleConstant.MuscleName.cardio.rawValue
    }
  }

  public struct MuscleInfo: Hashable, Sendable {
    public let id: Int
    public let name: String
    public let imageInfo: MuscleImageInfo?

    public init(id: Int, name: String, imageInfo: MuscleImageInfo? = nil) {
      self.id = id
      self.name = name
      self.imageInfo = imageInfo
    }

    public static func == (lhs: MuscleInfo, rhs: MuscleInfo) -> Bool {
      return lhs.name == rhs.name
    }
  }

  public enum MuscleData {
    public static let muscles: [MuscleName: MuscleInfo] = [
      .back: MuscleInfo(id: 9, name: "Back", imageInfo: MuscleImageInfo(backAnatomyIds: [9, 13, 15])),
      .cardio: MuscleInfo(id: 1, name: "Cardio", imageInfo: MuscleImageInfo(frontAnatomyIds: [6, 7, 10, 16], backAnatomyIds: [8, 7, 10])),
      .chest: MuscleInfo(id: 4, name: "Chest", imageInfo: MuscleImageInfo(frontAnatomyIds: [4])),
      .lowerLegs: MuscleInfo(id: 7, name: "Lower Legs", imageInfo: MuscleImageInfo(frontAnatomyIds: [7], backAnatomyIds: [7])),
      .shoulders: MuscleInfo(id: 2, name: "Shoulders", imageInfo: MuscleImageInfo(frontAnatomyIds: [2, 13])),
      .upperArms: MuscleInfo(id: 5, name: "Upper Arms", imageInfo: MuscleImageInfo(frontAnatomyIds: [5, 13])),
      .upperLegs: MuscleInfo(id: 8, name: "Upper Legs", imageInfo: MuscleImageInfo(frontAnatomyIds: [10, 15], backAnatomyIds: [8])),
      .waist: MuscleInfo(id: 6, name: "Waist", imageInfo: MuscleImageInfo(frontAnatomyIds: [6])),
    ]

    public static let back = muscles[.back]
    public static let cardio = muscles[.cardio]
    public static let chest = muscles[.chest]
    public static let lowerArms = muscles[.lowerArms]
    public static let lowerLegs = muscles[.lowerLegs]
    public static let neck = muscles[.neck]
    public static let shoulders = muscles[.shoulders]
    public static let upperArms = muscles[.upperArms]
    public static let upperLegs = muscles[.upperLegs]
    public static let waist = muscles[.waist]
  }
}
