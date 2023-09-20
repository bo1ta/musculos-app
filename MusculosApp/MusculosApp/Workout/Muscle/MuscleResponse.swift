//
//  MuscleResponse.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.09.2023.
//

import Foundation
import CoreData

struct MuscleResponse: Codable, DecodableModel {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [Muscle]
}

extension MuscleResponse {
    @discardableResult func toEntities(context: NSManagedObjectContext) -> [MuscleEntity] {
        return self.results.map { $0.toEntity(context: context) }
    }
}
