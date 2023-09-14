//
//  EquipmentModuleTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import Foundation
import XCTest

class EquipmentModuleTests: XCTestCase {
    override class func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    func testGetAllEquipmentSucceeds() async throws {
        let mockData = try XCTUnwrap(self.readFromFile(name: "getEquipment"))
        print(String(data: mockData, encoding: .utf8) ?? "")
        MockURLProtocol.requestHandler = { request in
            guard
                let url = request.url,
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            else { throw NetworkRequestError.badRequest }
            
            return (response, mockData)
        }

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        let urlSession = URLSession(configuration: configuration)
        let client = MusculosClient(urlSession: urlSession)
        let module = EquipmentModule(client: client)
        
        do {
            let equipments = try await module.getAllEquipment()
            XCTAssertEqual(equipments.count, 10)
            
            let first = try XCTUnwrap(equipments.first)
            XCTAssertEqual(first.id, 1)
            XCTAssertEqual(first.name, "Barbell")
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func getAllEquipmentFails() async throws {
        MockURLProtocol.requestHandler = { _ in throw NetworkRequestError.badRequest }
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        
        let urlSession = URLSession(configuration: configuration)
        let client = MusculosClient(urlSession: urlSession)
        let module = EquipmentModule(client: client)
        
        do {
            _ = try await module.getAllEquipment()
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "MusculosAppTests.NetworkRequestError")
        }
    }
}
