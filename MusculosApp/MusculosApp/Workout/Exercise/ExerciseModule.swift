//
//  ExerciseModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.09.2023.
//

import Foundation
import Combine

final class ExerciseModule {
    private let client: MusculosClientProtocol
    
    init(client: MusculosClientProtocol = MusculosClient()) {
        self.client = client
    }
    
    func getExercises(offset: Int = 0, limit: Int = 10) async throws -> [Exercise] {
        var request = APIRequest(method: .get, path: .exercise)
        request.queryParams = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        let responseData = try await self.client.dispatch(request)
        return try await Exercise.createArrayFrom(responseData)
    }
    
    func getExercises(by muscle: MuscleInfo) async throws -> [Exercise] {
        let path = Endpoint.exercisesByMuscle(name: muscle.name)
        let request = APIRequest(method: .get, path: path)
        let responseData = try await self.client.dispatch(request)
        return try await Exercise.createArrayFrom(responseData)
    }
    
    func getExercise(by opk: Int) async throws -> Exercise {
        var request = APIRequest(method: .get, path: .exercise)
        request.opk = String(opk)

        let responseData = try await self.client.dispatch(request)
        return try await Exercise.createFrom(responseData)
    }
    
    func searchExercise(by name: String) -> AnyPublisher<[Exercise], MusculosError> {
        let path = Endpoint.searchExercise(name: name)
        var request = APIRequest(method: .get, path: path)
        request.queryParams = [
            URLQueryItem(name: "limit", value: "10")
        ]
        
        let responseData: AnyPublisher<[Exercise], MusculosError> = self.client.dispatchPublisher(request)
        return responseData
    }
}
