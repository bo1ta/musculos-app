//
//  MuscleModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.09.2023.
//

import Foundation

final class MuscleModule {
    private let client: MusculosClient
    
    init(client: MusculosClient) {
        self.client = client
    }
    
    func getAllMuscles(with limit: Int? = nil, and offset: Int? = nil) async throws -> MuscleResponse {
        var request = APIRequest(method: .get, path: .muscle)
        
        var queryItems: [URLQueryItem] = []
        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        if let offset = offset {
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }
        request.queryParams = queryItems
        
        let responseData = try await self.client.dispatch(request)
        return try await MuscleResponse.createFrom(responseData)
    }
    
    func getMuscle(by opk: Int) async throws -> Muscle {
        var request = APIRequest(method: .get, path: .muscle)
        request.opk = String(opk)
        
        let responseData = try await self.client.dispatch(request)
        return try await Muscle.createFrom(responseData)
    }
    
}
