//
//  IntroductionModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.06.2023.
//

import Foundation
import Combine

struct IntroductionModule: NetworkModule {
    var dispatcher: NetworkDispatcher
    
    init(dispatcher: NetworkDispatcher = NetworkDispatcher()) {
        self.dispatcher = dispatcher
    }
    
    func getQuestions() -> AnyPublisher<IntroductionResponse, NetworkRequestError> {
        let request = IntroductionRequest()
        let client = MusculosClient(baseURL: request.path, networkDispatcher: self.dispatcher)
        return client.dispatch(request)
            .eraseToAnyPublisher()
    }
}
