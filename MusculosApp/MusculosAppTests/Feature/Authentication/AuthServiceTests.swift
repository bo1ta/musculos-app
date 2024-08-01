//
//  AuthServiceTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 26.03.2024.
//

import XCTest
import Factory

@testable import MusculosApp

final class AuthServiceTests: XCTestCase, MusculosTestBase {
  override func tearDown() {
    MockURLProtocol.clear()
    super.tearDown()
  }
  
  func testLoginSucceeds() async throws {
    let requestExpectation = self.expectation(description: "should make a network request")
    let succeedsExpectation = self.expectation(description: "should succeed")

    let configuration = self.createMockSession(jsonFileName: "authenticationResult", expectation: requestExpectation)
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)

    Container.shared.client.register { client }
    defer { Container.shared.client.reset() }

    let service = AuthService()
    do {
      let session = try await service.login(email: "email", password: "password")
      succeedsExpectation.fulfill()
    } catch {
      XCTFail("Should not fail!")
    }
    
    await fulfillment(of: [requestExpectation, succeedsExpectation], timeout: 1)
  }
  
  func testLoginFails() async throws {
    let requestExpectation = self.expectation(description: "should make a network request")
    let failsExpectation = self.expectation(description: "should fail")

    let configuration = self.createMockSession(expectation: requestExpectation, shouldFail: true)
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = AuthService(client: client, dataStore: MockDataStore())
    
    do {
      _ = try await module.login(email: "email", password: "password")
      XCTFail("Should not succeed!")
    } catch {
      failsExpectation.fulfill()
    }
    
    await fulfillment(of: [failsExpectation, requestExpectation], timeout: 1)
  }
  
  func testRegisterSucceeds() async throws {
    let requestExpectation = self.expectation(description: "should make a network request")
    let succeedsExpectation = self.expectation(description: "should succeed")
    let createUserExpectation = self.expectation(description: "should save user in the data store")

    let configuration = self.createMockSession(jsonFileName: "authenticationResult", expectation: requestExpectation)
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let mockDataStore = MockDataStore()
    mockDataStore.createUserExpectation = createUserExpectation
    let module = AuthService(client: client, dataStore: mockDataStore)
    
    do {
      try await module.register(email: "email", password: "password", username: "username", fullName: "full name")
      succeedsExpectation.fulfill()
    } catch {
      XCTFail("Should not fail!")
    }
    
    await fulfillment(of: [requestExpectation, succeedsExpectation, createUserExpectation], timeout: 1)
  }
  
  func testRegisterFails() async throws {
    let requestExpectation = self.expectation(description: "should make a network request")
    let failsExpectation = self.expectation(description: "should fail")
    
    let configuration = self.createMockSession(expectation: requestExpectation, shouldFail: true)
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = AuthService(client: client, dataStore: MockDataStore())
    
    do {
      _ = try await module.login(email: "email", password: "password")
      XCTFail("Should not succeed!")
    } catch {
      failsExpectation.fulfill()
    }
    
    await fulfillment(of: [requestExpectation, failsExpectation], timeout: 1)
  }
}

extension AuthServiceTests {
  class MockDataStore: UserDataStoreProtocol {
    var updateUserExpectation: XCTestExpectation?
    func updateUser(gender: String?, weight: Int?, height: Int?, primaryGoalId: Int?, level: String?, isOnboarded: Bool) async throws {
      updateUserExpectation?.fulfill()
    }
    
    
    var createUserExpectation: XCTestExpectation?
    func createUser(person: User) async throws {
      createUserExpectation?.fulfill()
    }
        
    var expectedUser: User?
    func loadCurrentUser() async -> User? {
      return expectedUser
    }
  }
//}
