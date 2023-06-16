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
    
}

struct Question: Codable {
    var id: Int
    var content: String
    var answers: [Answer]
}

struct IntroductionResponse: Codable {
    var questions: [Question]
}

struct IntroductionRequest: Request {
    typealias ReturnType = IntroductionResponse

    var path: String = APIEndpoint.baseWithEndpoint(endpoint: .questions)
    var body: [String : Any] = [:]
}
