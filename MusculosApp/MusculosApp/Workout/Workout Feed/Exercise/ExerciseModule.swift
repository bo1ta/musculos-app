//
//  ExerciseModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.09.2023.
//

import Foundation
import Combine

class ExerciseModule: NetworkModule {
    var dispatcher: NetworkDispatcher
    
    init(dispatcher: NetworkDispatcher = NetworkDispatcher()) {
        self.dispatcher = dispatcher
    }
    
//    func getExercises(_ page: Int = 0) -> AnyPublisher<[Exercise], NetworkRequestError> {
//
//    }
}
