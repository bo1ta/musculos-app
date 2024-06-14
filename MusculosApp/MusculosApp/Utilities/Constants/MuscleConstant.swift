//
//  MuscleConstant.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.09.2023.
//

import Foundation

struct MuscleConstant {
  enum MuscleName: String, CaseIterable {
    case back, cardio, chest, lowerArms, lowerLegs, neck, shoulders, upperArms, upperLegs, waist
  }

  struct MuscleImageInfo: Hashable {
    let uuid = UUID()

    let frontAnatomyIds: [Int]?
    let backAnatomyIds: [Int]?

    init(frontAnatomyIds: [Int]? = nil, backAnatomyIds: [Int]? = nil) {
      self.frontAnatomyIds = frontAnatomyIds
      self.backAnatomyIds = backAnatomyIds
    }
    
    static func ==(_ lhs: MuscleImageInfo, rhs: MuscleImageInfo) -> Bool {
      return lhs.uuid == rhs.uuid
    }
  }
  
  struct MuscleInfo: Hashable {
    let id: Int
    let name: String
    let imageInfo: MuscleImageInfo?

    init(id: Int, name: String, imageInfo: MuscleImageInfo? = nil) {
      self.id = id
      self.name = name
      self.imageInfo = imageInfo
    }
    
    static func ==(lhs: MuscleInfo, rhs: MuscleInfo) -> Bool {
      return lhs.name == rhs.name
    }
  }
  
  struct MuscleData {
    static let muscles: [MuscleName: MuscleInfo] = [
      .back: MuscleInfo(id: 9, name: "Back", imageInfo: MuscleImageInfo(backAnatomyIds: [9, 13, 15])),
      .cardio: MuscleInfo(id: 1, name: "Cardio", imageInfo: MuscleImageInfo(frontAnatomyIds: [6, 7, 10, 16], backAnatomyIds: [8, 7, 10])),
      .chest: MuscleInfo(id: 4, name: "Chest", imageInfo: MuscleImageInfo(frontAnatomyIds: [4])),
      .lowerLegs: MuscleInfo(id: 7, name: "Lower Legs", imageInfo: MuscleImageInfo(frontAnatomyIds: [7], backAnatomyIds: [7])),
      .shoulders: MuscleInfo(id: 2, name: "Shoulders", imageInfo: MuscleImageInfo(frontAnatomyIds: [2, 13])),
      .upperArms: MuscleInfo(id: 5, name: "Upper Arms", imageInfo: MuscleImageInfo(frontAnatomyIds: [5, 13])),
      .upperLegs: MuscleInfo(id: 8, name: "Upper Legs", imageInfo: MuscleImageInfo(frontAnatomyIds: [10, 15], backAnatomyIds: [8])),
      .waist: MuscleInfo(id: 6, name: "Waist", imageInfo: MuscleImageInfo(frontAnatomyIds: [6]))
    ]

    static let back = muscles[.back]
    static let cardio = muscles[.cardio]
    static let chest = muscles[.chest]
    static let lowerArms = muscles[.lowerArms]
    static let lowerLegs = muscles[.lowerLegs]
    static let neck = muscles[.neck]
    static let shoulders = muscles[.shoulders]
    static let upperArms = muscles[.upperArms]
    static let upperLegs = muscles[.upperLegs]
    static let waist = muscles[.waist]
  }
}
