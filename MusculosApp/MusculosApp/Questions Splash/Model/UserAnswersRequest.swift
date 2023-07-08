//
//  IntroductionRequest.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation

struct IntroductionRequest: Request {
    typealias ReturnType = [Question]
    var path: String = APIEndpoint.baseWithEndpoint(endpoint: .questions)
}

struct UserAnswersRequest: Request {
    typealias ReturnType = [Answer]
    
    var path: String = APIEndpoint.baseWithEndpoint(endpoint: .userAnswers)
    
    var body: [String: Any]?
    
    init(body: [String: Any]?) {
        self.body = body
    }
}
