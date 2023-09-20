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
    
    func getAllExercise() async throws -> ExerciseResponse {
        var request = APIRequest(method: .get, path: .exercise)
        request.queryParams = [URLQueryItem(name: "language", value: "2")]
        
        let responseData = try await self.client.dispatch(request)
        return try await ExerciseResponse.createFrom(responseData)
    }
    
    func getExercise(by opk: Int) async throws -> Exercise {
        var request = APIRequest(method: .get, path: .exercise)
        request.opk = String(opk)

        let responseData = try await self.client.dispatch(request)
        return try await Exercise.createFrom(responseData)
    }
    
    func searchExercise(with term: String) -> AnyPublisher<SearchExerciseResponse, MusculosError> {
        var request = APIRequest(method: .get, path: .searchExercise)
        request.queryParams = [
            URLQueryItem(name: "language", value: "2"),
            URLQueryItem(name: "term", value: term)
        ]
        
        let responseData: AnyPublisher<SearchExerciseResponse, MusculosError> = self.client.dispatchPublisher(request)
        return responseData
    }
}

struct SearchExerciseResponse: Codable {
    struct PreviewExercise: Codable, Identifiable {
        var id: Int
        var baseId: Int
        var name: String
        var category: String
        var image: String?
        var imageThumbnail: String?
    }
    
    struct SearchExercise: Codable {
        var value: String
        var data: PreviewExercise
    }
    
    var suggestions: [SearchExercise]
}
