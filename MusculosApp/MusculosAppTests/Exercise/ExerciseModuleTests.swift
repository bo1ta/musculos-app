//
//  ExerciseModuleTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 20.09.2023.
//

import Foundation
import XCTest

@testable import MusculosApp

class ExerciseModuleTests: XCTestCase {
  override class func tearDown() {
    MockURLProtocol.clear()
    super.tearDown()
  }
  
  private func setupNetworkConfiguration(shouldFail: Bool = false, expectation: XCTestExpectation? = nil) -> URLSessionConfiguration {
    MockURLProtocol.expectation = expectation
    MockURLProtocol.requestHandler = { request in
      guard !shouldFail, let url = request.url else { throw MusculosError.badRequest }
      
      let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
      let data = try XCTUnwrap(self.readFromFile(name: "getExercises"))
      return (response, data)
    }
    
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocol.self]
    return configuration
  }
  
  func testGetExercisesSucceeds() async throws {
    let expectation = self.expectation(description: "should make a network request")
    let configuration = setupNetworkConfiguration(expectation: expectation)
    
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = ExerciseModule(client: client)
    
    do {
      let exercises = try await module.getExercises()
      XCTAssertEqual(exercises.count, 20)
    } catch {
      XCTFail(error.localizedDescription)
    }
    
    await fulfillment(of: [expectation], timeout: 1)
  }
  
  func testGetExercisesFails() async throws {
    let expectation = self.expectation(description: "should fail")
    let configuration = setupNetworkConfiguration(shouldFail: true)
    
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = ExerciseModule(client: client)
    
    do {
      _ = try await module.getExercises()
      XCTFail("Should not succeed!")
    } catch {
      expectation.fulfill()
    }
    
    await fulfillment(of: [expectation])
  }
  
  func testSearchByMuscleQuerySucceeds() async throws {
    let expectation = self.expectation(description: "should succeed")
    let configuration = setupNetworkConfiguration(expectation: expectation)
    
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = ExerciseModule(client: client)
    
    do {
      let exercises = try await module.searchByMuscleQuery("muscle")
      XCTAssertEqual(exercises.count, 20)
    } catch {
      XCTFail(error.localizedDescription)
    }
    
    await fulfillment(of: [expectation])
  }
  
  func testSearchByMuscleQueryFails() async throws {
    let expectation = self.expectation(description: "should fail")
    let configuration = setupNetworkConfiguration(shouldFail: true)
    
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = ExerciseModule(client: client)
    
    do {
      _ = try await module.searchByMuscleQuery("muscle")
      XCTFail("Should not succeed!")
    } catch {
      expectation.fulfill()
    }
    
    await fulfillment(of: [expectation])
  }
}
