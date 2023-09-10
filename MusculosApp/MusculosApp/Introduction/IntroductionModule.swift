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
        let responseData = try await self.client.dispatch(request)
        return try await Question.createArrayFrom(responseData)
    }
    
    func postAnswers(answers: [Answer]) async throws {
        var request = APIRequest(method: .post, path: .userAnswers)
        request.body = answers.asDictionary
        _ = try await self.client.dispatch(request)
    }
}
