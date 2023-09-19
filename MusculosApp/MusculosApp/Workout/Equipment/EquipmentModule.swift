//
//  EquipmentModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.09.2023.
//

import Foundation


final class EquipmentModule {
    private let client: MusculosClientProtocol
    
    init(client: MusculosClientProtocol) {
        self.client = client
    }
    
    func getAllEquipment() async throws -> [Equipment] {
        let request = APIRequest(method: .get, path: .equipment)
        let responseData = try await self.client.dispatch(request)
        let equipmentResponse = try await EquipmentResponse.createFrom(responseData)
        return equipmentResponse.results
    }
}
