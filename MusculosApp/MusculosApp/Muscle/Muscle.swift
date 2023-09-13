//
//  Muscle.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.09.2023.
//

import Foundation

struct Muscle: Codable, DecodableModel {
    var id: Int
    var latinName: String
    var englishName: String
    var isFront: Bool
    var imageUrlMain: String
    var imageUrlSecondary: String
    
    enum CodingKeys: String, CodingKey {
        case id, imageUrlMain, imageUrlSecondary, isFront
        case latinName = "name"
        case englishName = "name_en"
    }
}

extension Muscle {
    init(muscleEntity: MuscleEntity) {
        self.id = muscleEntity.id
        self.latinName = muscleEntity.latinName
        self.englishName = muscleEntity.englishName
        self.isFront = muscleEntity.isFront
        self.imageUrlMain = muscleEntity.imageUrlMain
        self.imageUrlSecondary = muscleEntity.imageUrlSecondary
    }
    
    @discardableResult func toEntity() -> MuscleEntity {
        let muscleEntity = MuscleEntity(context: DataController.shared.container.viewContext)
        muscleEntity.id = self.id
        muscleEntity.englishName = self.englishName
        muscleEntity.latinName = self.latinName
        muscleEntity.isFront = self.isFront
        muscleEntity.imageUrlMain = self.imageUrlMain
        muscleEntity.imageUrlSecondary = self.imageUrlSecondary
        return muscleEntity
    }
}

struct MuscleResponse: Codable, DecodableModel {
    var count: Int
    var next: String
    var previous: String
    var results: [Muscle]
}

extension MuscleResponse {
    @discardableResult func toEntities() -> [MuscleEntity] {
        return self.results.map { $0.toEntity() }
    }
}
