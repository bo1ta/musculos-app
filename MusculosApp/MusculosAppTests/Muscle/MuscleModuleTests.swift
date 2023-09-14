//
//  MuscleModuleTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import XCTest

final class MuscleModuleTests: XCTestCase {
    override class func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    func testGetAllMusclesSuccess() async throws {
        let mockData = try XCTUnwrap(self.readFromFile(name: "getMuscles"))
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkRequestError.badRequest
            }
            
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
            return (response, mockData)
        }

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        let urlSession = URLSession.init(configuration: configuration)
        let client = MusculosClient(urlSession: urlSession)
        let module = MuscleModule(client: client)
    
        do {
            let response = try await module.getAllMuscles()
            let muscles = response.results
            XCTAssertEqual(muscles.count, 15)
            
            let first = try XCTUnwrap(muscles.first)
            XCTAssertEqual(first.id, 2)
            XCTAssertEqual(first.latinName, "Anterior deltoid")
            XCTAssertTrue(first.isFront)
        } catch {
            XCTFail("Test failed with error: \(error)")
        }
    }
    
    func testGetAllMusclesFailure() async throws {
        MockURLProtocol.requestHandler = { _ in
            throw NetworkRequestError.badRequest
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        
        let urlSession = URLSession.init(configuration: configuration)
        let client = MusculosClient(urlSession: urlSession)
        let module = MuscleModule(client: client)
        
        do {
            _ = try await module.getAllMuscles()
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "MusculosAppTests.NetworkRequestError")
            XCTAssertEqual(nsError.code, 4)
        }
    }
}
