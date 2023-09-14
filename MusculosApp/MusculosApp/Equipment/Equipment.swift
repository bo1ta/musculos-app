//
//  Equipment.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.09.2023.
//

import Foundation

struct Equipment: Codable {
    var id: Int
    var name: String
}

extension Equipment {
    init(entity: EquipmentEntity) {
        self.id = entity.id
        self.name = entity.name
    }
    
    @discardableResult func toEntity() -> EquipmentEntity {
        let entity = EquipmentEntity(context: DataController.shared.container.viewContext)
        entity.id = self.id
        entity.name = self.name
        return entity
    }
}

struct EquipmentResponse: Codable, DecodableModel {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Equipment]
}

extension EquipmentResponse {
    @discardableResult func toEntities() -> [EquipmentEntity] {
        let entities: [EquipmentEntity] = self.results.map { $0.toEntity() }
        return entities
    }
}

