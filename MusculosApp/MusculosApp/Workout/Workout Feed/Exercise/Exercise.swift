//
//  Exercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.09.2023.
//

import Foundation

// Example payload
/* {
         "id": 1314,
         "uuid": "d09f38a4-2c88-46ef-a847-cb66289d250b",
         "name": "Addominali",
         "exercise_base": 167,
         "description": "<ol><li>Sdraiati a pancia in su sul pavimento con le ginocchia piegate.</li><li>Solleva il busto verso il bacino, a 30° / 40° dal suolo. Le mani possono essere dietro o accanto al collo o incrociate sul petto.</li><li>Ripeti</li></ol>",
         "created": "2023-08-06T10:17:17.349000+02:00",
         "category": 10,
         "muscles": [
             6
         ],
         "muscles_secondary": [
             3
         ],
         "equipment": [
             4
         ],
         "language": 13,
         "license": 2,
         "license_author": "albanobattistella (imported from Feeel)",
         "variations": [
             1314,
             1243,
             2060,
             1186
         ],
         "author_history": []
     } */

struct Exercise: Codable {
    var id: Int
    var uuid: String
    var name: String
    var exerciseBase: String
    var description: String
    var created: String
    var category: Int
    var muscles: [Int]
    var musclesSecondary: [Int]
    var equipment: [Int]
    var variations: [Int]
    
    enum CodingKeys: String, CodingKey {
        case exerciseBase = "exercise_base"
        case musclesSecondary = "muscles_secondary"
        case id, uuid, name, description, created, category, muscles, equipment, variations
    }
}
