//
//  UserAnswersRequest.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation

struct UserAnswersRequest: Request {
    typealias ReturnType = [Answer]
    
    var path: String = APIEndpoint.baseWithEndpoint(endpoint: .authentication)
    
    var body: [String: Any]?
    
    init(body: [String: Any]?) {
        self.body = body
    }
}
