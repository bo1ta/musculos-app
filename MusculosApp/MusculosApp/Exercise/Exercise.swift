//
//  Exercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.09.2023.
//

import Foundation

struct Exercise: Codable, DecodableModel {
    var id: Int
    var uuid: UUID
    var name: String
    var exerciseBase: Int
    var description: String
    var created: String
    var category: Int
    var musclesId: [Int]
    var musclesSecondaryId: [Int]
    var equipmentId: [Int]
    var language: Int
    var license: Int
    var licenseAuthor: String
    var variations: [Int]
    
    var muscles: [Muscle] = []
    var musclesSecondary: [Muscle] = []
    var equipments: [Equipment] = []
    
    enum CodingKeys: String, CodingKey {
        case id, uuid, name, exerciseBase, description, created, category, language, license, licenseAuthor, variations
        case musclesId = "muscles"
        case musclesSecondaryId = "muscles_secondary"
        case equipmentId = "equipment"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.uuid = try container.decode(UUID.self, forKey: .uuid)
        self.name = try container.decode(String.self, forKey: .name)
        self.exerciseBase = try container.decode(Int.self, forKey: .exerciseBase)
        self.description = try container.decode(String.self, forKey: .description)
        self.created = try container.decode(String.self, forKey: .created)
        self.category = try container.decode(Int.self, forKey: .category)
        self.language = try container.decode(Int.self, forKey: .language)
        self.license = try container.decode(Int.self, forKey: .license)
        self.licenseAuthor = try container.decode(String.self, forKey: .licenseAuthor)
        self.variations = try container.decode([Int].self, forKey: .variations)
        self.equipmentId = try container.decode([Int].self, forKey: .equipmentId)
        self.musclesId = try container.decode([Int].self, forKey: .musclesId)
        self.musclesSecondaryId = try container.decode([Int].self, forKey: .musclesSecondaryId)
    }
}

struct ExerciseResponse: Codable, DecodableModel {
    var count: Int
    var next: String
    var previous: String
    var results: [Exercise]
}
