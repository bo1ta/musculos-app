//
//  IntroQuestionsRequest.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.06.2023.
//

import Foundation

struct Answer: Codable {
    var id: Int
    var content: String
    var questionId: Int
}

extension Answer: Hashable {
    static func == (lhs: Answer, rhs: Answer) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Question: Codable {
    var id: Int
    var content: String
    var answers: [Answer]
}

struct IntroductionRequest: Request {
    typealias ReturnType = [Question]
    var path: String = APIEndpoint.baseWithEndpoint(endpoint: .questions)
}
