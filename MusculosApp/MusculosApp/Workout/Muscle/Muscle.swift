//
//  Muscle.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.09.2023.
//

import Foundation
import CoreData
import SwiftUI

struct Muscle: Codable, DecodableModel {
    var id: Int
    var latinName: String
    var englishName: String?
    var isFront: Bool
    var imageUrlMain: String
    var imageUrlSecondary: String
    
    enum CodingKeys: String, CodingKey {
        case id, imageUrlMain, imageUrlSecondary, isFront
        case latinName = "name"
        case englishName = "name_en"
    }
}

// MARK: - Helpers

extension Muscle {
    init(entity: MuscleEntity) {
        self.id = entity.id
        self.latinName = entity.latinName
        self.englishName = entity.englishName
        self.isFront = entity.isFront
        self.imageUrlMain = entity.imageUrlMain
        self.imageUrlSecondary = entity.imageUrlSecondary
    }
    
    @discardableResult func toEntity(context: NSManagedObjectContext) -> MuscleEntity {
        let muscleEntity = MuscleEntity(context: context)
        muscleEntity.id = self.id
        muscleEntity.englishName = self.englishName ?? ""
        muscleEntity.latinName = self.latinName
        muscleEntity.isFront = self.isFront
        muscleEntity.imageUrlMain = self.imageUrlMain
        muscleEntity.imageUrlSecondary = self.imageUrlSecondary
        return muscleEntity
    }
}

extension Muscle: Identifiable { }

// MARK: - Computed properties

extension Muscle {
    var primaryImage: Image {
        return Image("muscles/main/muscle-\(self.id)")
    }
}
