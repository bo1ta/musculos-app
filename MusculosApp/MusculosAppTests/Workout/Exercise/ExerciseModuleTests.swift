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

//  func testGetAllExercisesSucceeds() async throws {
//    let networkRequestExpectation = self.expectation(description: "should make a network request")
//    MockURLProtocol.expectation = networkRequestExpectation
//    MockURLProtocol.requestHandler = { request in
//      guard let url = request.url else { throw MusculosError.badRequest }
//
//      let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
//      let data = try XCTUnwrap(self.readFromFile(name: "getExercises"))
//      return (response, data)
//    }
//
//    let configuration = URLSessionConfiguration.default
//    configuration.protocolClasses = [MockURLProtocol.self]
//
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//    let module = ExerciseDBModule(client: client)
//
//    do {
//      let exercises = try await module.getExercises()
//      XCTAssertEqual(exercises.count, 5)
//
//      let first = try XCTUnwrap(exercises.first)
//      XCTAssertEqual(first.id, "345")
//      XCTAssertEqual(first.name, "2 Handed Kettlebell Swing")
//    } catch {
//      XCTFail(error.localizedDescription)
//    }
//
//    await fulfillment(of: [networkRequestExpectation], timeout: 1)
//  }
//
//  func testGetAllEquipmentFails() async throws {
//    MockURLProtocol.requestHandler = { _ in throw MusculosError.badRequest }
//    let configuration = URLSessionConfiguration.default
//    configuration.protocolClasses = [MockURLProtocol.self]
//
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//    let module = ExerciseDBModule(client: client)
//
//    do {
//      _ = try await module.getExercises()
//    } catch {
//      let nsError = error as NSError
//      XCTAssertEqual(nsError.domain, "MusculosApp.MusculosError")
//    }
//  }
}
