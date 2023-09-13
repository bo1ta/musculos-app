//
//  Exercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.09.2023.
//

import Foundation

struct Exercise: Codable, DecodableModel {
    var id: Int
    var uuid: String
    var name: String
    var exerciseBase: Int
    var description: String
    var created: String
    var category: Int
    var musclesId: [Int]
    var equipmentId: [Int]
    var language: Int
    var license: Int
    var licenseAuthor: String
//    var variations: [Int]
//    var musclesSecondaryId: [Int]
    
    var muscles: [Muscle] = []
    var musclesSecondary: [Muscle] = []
    var equipments: [Equipment] = []
    
    enum CodingKeys: String, CodingKey {
        case id, uuid, name, exerciseBase, description, created, category, language, license, licenseAuthor
        case musclesId = "muscles"
        case equipmentId = "equipment"
//        case musclesSecondaryId = "muscles_secondary"
//        case variations
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.name = try container.decode(String.self, forKey: .name)
        self.exerciseBase = try container.decode(Int.self, forKey: .exerciseBase)
        self.description = try container.decode(String.self, forKey: .description)
        self.created = try container.decode(String.self, forKey: .created)
        self.category = try container.decode(Int.self, forKey: .category)
        self.language = try container.decode(Int.self, forKey: .language)
        self.license = try container.decode(Int.self, forKey: .license)
        self.licenseAuthor = try container.decode(String.self, forKey: .licenseAuthor)
        self.equipmentId = try container.decode([Int].self, forKey: .equipmentId)
        self.musclesId = try container.decode([Int].self, forKey: .musclesId)
//        self.musclesSecondaryId = try container.decode([Int].self, forKey: .musclesSecondaryId)
//        self.variations = try container.decode([Int].self, forKey: .variations)
    }
    
    init(entity: ExerciseEntity) {
        self.id = entity.id
        self.uuid = entity.uuid
        self.name = entity.name
        self.exerciseBase = entity.exerciseBase
        self.description = entity.information
        self.created = entity.created
        self.category = entity.category
        self.language = entity.language
        self.license = entity.license
        self.licenseAuthor = entity.author
        
        if let equipments = entity.equipments as? Set<EquipmentEntity> {
            self.equipmentId = equipments.map { $0.id }
            self.equipments = equipments.map { Equipment(entity: $0) }
        } else {
            self.equipmentId = []
        }
        
        if let muscles = entity.muscles as? Set<MuscleEntity> {
            self.musclesId = muscles.map { $0.id }
            self.muscles = muscles.map { Muscle(entity: $0) }
        } else {
            self.musclesId = []
        }
    }
    
    @discardableResult func toEntity() -> ExerciseEntity {
        let entity = ExerciseEntity(context: DataController.shared.container.viewContext)
        entity.id = self.id
        entity.uuid = self.uuid
        entity.name = self.name
        entity.exerciseBase = self.exerciseBase
        entity.information = self.description
        entity.created = self.created
        entity.category = self.category
        entity.language = self.language
        entity.author = self.licenseAuthor
        return entity
    }
}

struct ExerciseResponse: Codable, DecodableModel {
    var count: Int
    var next: String
    var previous: String
    var results: [Exercise]
}
