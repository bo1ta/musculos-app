//
//  MuscleData.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.09.2023.
//

import Foundation

enum MuscleName: String {
    case back, cardio, chest, lowerArms, lowerLegs, neck, shoulders, upperArms, upperLegs, waist
}

struct MuscleInfo {
    let name: String
    let id: Int
    let isFront: Bool
}

extension MuscleInfo: Hashable {
    static func ==(_ lhs: MuscleInfo, rhs: MuscleInfo) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MuscleData {
    static let muscles: [MuscleName: MuscleInfo] = [
        .back: MuscleInfo(name: "Back", id: 9, isFront: false),
        .cardio: MuscleInfo(name: "Cardio", id: 2, isFront: false),
        .chest: MuscleInfo(name: "Chest", id: 3, isFront: true),
        .lowerArms: MuscleInfo(name: "Lower Arms", id: 4, isFront: true),
        .lowerLegs: MuscleInfo(name: "Lower Legs", id: 7, isFront: true),
        .neck: MuscleInfo(name: "Neck", id: 6, isFront: true),
        .shoulders: MuscleInfo(name: "Shoulders", id: 1, isFront: true),
        .upperArms: MuscleInfo(name: "Upper Arms", id: 5, isFront: true),
        .upperLegs: MuscleInfo(name: "Upper Legs", id: 8, isFront: true),
        .waist: MuscleInfo(name: "Waist", id: 10, isFront: true)
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
