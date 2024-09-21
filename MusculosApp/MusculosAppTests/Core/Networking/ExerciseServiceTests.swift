//
//  ExerciseServiceTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 20.09.2023.
//

import Foundation
import XCTest
import Factory
import Models

@testable import MusculosApp

//class ExerciseServiceTests: XCTestCase, MusculosTestBase {
//  override class func tearDown() {
//    MockURLProtocol.clear()
//    super.tearDown()
//  }
//  
//  func testGetExercisesSucceeds() async throws {
//    let expectation = self.expectation(description: "should make a network request")
//    
//    let configuration = self.createMockSession(jsonFileName: "getExercises", expectation: expectation)
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//    let module = ExerciseService(client: client, dataStore: StubExerciseDataStore())
//    
//    do {
//      let exercises = try await module.getExercises()
//      XCTAssertEqual(exercises.count, 20)
//    } catch {
//      XCTFail(error.localizedDescription)
//    }
//    
//    await fulfillment(of: [expectation], timeout: 1)
//  }
//  
//  func testGetExercisesFails() async throws {
//    let failureExpectation = self.expectation(description: "should fail")
//    let networkRequestExpectation = self.expectation(description: "should make network request")
//    let configuration = self.createMockSession(expectation: networkRequestExpectation, shouldFail: true)
//    
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//    let module = ExerciseService(client: client, dataStore: StubExerciseDataStore())
//    
//    do {
//      _ = try await module.getExercises()
//      XCTFail("Should not succeed!")
//    } catch {
//      failureExpectation.fulfill()
//    }
//    
//    await fulfillment(of: [failureExpectation, networkRequestExpectation])
//  }
//  
//  func testSearchByMuscleQuerySucceeds() async throws {
//    let expectation = self.expectation(description: "should succeed")
//    let configuration = self.createMockSession(jsonFileName: "getExercises", expectation: expectation)
//    
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//    let module = ExerciseService(client: client, dataStore: StubExerciseDataStore())
//    
//    do {
//      let exercises = try await module.searchByMuscleQuery("muscle")
//      XCTAssertEqual(exercises.count, 20)
//    } catch {
//      XCTFail(error.localizedDescription)
//    }
//    
//    await fulfillment(of: [expectation])
//  }
//  
//  func testSearchByMuscleQueryFails() async throws {
//    let expectation = self.expectation(description: "should fail")
//    let configuration = self.createMockSession(shouldFail: true)
//    
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//    let module = ExerciseService(client: client, dataStore: StubExerciseDataStore())
//    
//    do {
//      _ = try await module.searchByMuscleQuery("muscle")
//      XCTFail("Should not succeed!")
//    } catch {
//      expectation.fulfill()
//    }
//    
//    await fulfillment(of: [expectation])
//  }
//}
