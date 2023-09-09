//
//  IntroductionModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.06.2023.
//

import Foundation
import Combine

struct IntroductionModule {
    var client: MusculosClient
    
    init(client: MusculosClient = MusculosClient()) {
        self.client = client
    }
    
    func getQuestions() async throws -> [Question] {
        let request = APIRequest(method: .get, path: .questions)
        let responseData = try await self.client.dispatch(request: request)
        return try await Question.createArrayFrom(responseData)
    }
}
