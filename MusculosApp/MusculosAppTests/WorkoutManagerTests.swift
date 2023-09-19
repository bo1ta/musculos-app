//
//  WorkoutManagerTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import Foundation
import XCTest
import CoreData

class WorkoutManagerTests: XCTestCase {
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        MockURLProtocol.expectation = nil
        super.tearDown()
    }
    
    func testFetchEquipment() async throws {
        let equipmentFetchRequest = NSFetchRequest<EquipmentEntity>(entityName: "EquipmentEntity")

        // Count should be 0 since we start with a clean data store
        let coreDataStack = CoreDataTestStack()
        var equipmentEntities = try coreDataStack.mainContext.fetch(equipmentFetchRequest)
        XCTAssertEqual(equipmentEntities.count, 0)
        
        // makes a network request in absence of core data models
        let networkRequestExpectation = self.expectation(description: "should make network request")
        let mockData = try XCTUnwrap(self.readFromFile(name: "getEquipment"))
        
        MockURLProtocol.expectation = networkRequestExpectation
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MusculosError.badRequest }
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
            return (response, mockData)
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        
        let urlSession = URLSession(configuration: configuration)
        let client = MusculosClient(urlSession: urlSession)
        
        let workoutManager = WorkoutManager(client: client, context: coreDataStack.mainContext)
        do {
            let equipments = try await workoutManager.fetchAllEquipments()
            XCTAssertFalse(equipments.isEmpty)
            
            equipmentEntities = try coreDataStack.mainContext.fetch(equipmentFetchRequest)
            XCTAssertEqual(equipmentEntities.count, equipments.count)
        } catch {
            XCTFail("Test failed with error: \(error)")
        }
        
        await fulfillment(of: [networkRequestExpectation], timeout: 1)
    }
}
