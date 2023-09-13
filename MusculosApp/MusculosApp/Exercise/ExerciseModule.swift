//
//  ExerciseModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.09.2023.
//

import Foundation

final class ExerciseModule {
    private let client: MusculosClient
    
    init(client: MusculosClient = MusculosClient()) {
        self.client = client
    }
    
    func getAllExercise() async throws -> ExerciseResponse {
        let request = APIRequest(method: .get, path: .exercise)
        let responseData = try await self.client.dispatch(request)
        return try await ExerciseResponse.createFrom(responseData)
    }
    
    func getExercise(by opk: Int) async throws -> Exercise {
        var request = APIRequest(method: .get, path: .exercise)
        request.opk = String(opk)

        let responseData = try await self.client.dispatch(request)
        return try await Exercise.createFrom(responseData)
    }
}
