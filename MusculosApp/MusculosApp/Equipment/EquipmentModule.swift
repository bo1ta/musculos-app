//
//  EquipmentModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.09.2023.
//

import Foundation


final class EquipmentModule {
    private let client: MusculosClient
    
    init(client: MusculosClient) {
        self.client = client
    }
    
    func getAllEquipment() async throws -> EquipmentResponse {
        let request = APIRequest(method: .get, path: .equipment)
        let responseData = try await self.client.dispatch(request)
        return try await EquipmentResponse.createFrom(responseData)
    }
}
