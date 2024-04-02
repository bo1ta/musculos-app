//
//  AuthModuleTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 26.03.2024.
//

import XCTest

@testable import MusculosApp

final class AuthModuleTests: XCTestCase, MusculosTestBase {
  override class func tearDown() {
    MockURLProtocol.clear()
    super.tearDown()
  }
  
  func testLoginSucceeds() async throws {
    let requestExpectation = self.expectation(description: "should make a network request")
    let succeedsExpectation = self.expectation(description: "should succeed")

    let configuration = self.createMockSession(jsonFileName: "authenticationResult", expectation: requestExpectation)
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = AuthModule(client: client)
  
    do {
      let token = try await module.login(email: "email", password: "password")
      XCTAssertEqual(token, "secret-token")
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
    let module = AuthModule(client: client)
    
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

    let configuration = self.createMockSession(jsonFileName: "authenticationResult", expectation: requestExpectation)
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = AuthModule(client: client)
    
    do {
      let token = try await module.register(email: "email", password: "password", username: "username", fullName: "full name")
      XCTAssertEqual(token, "secret-token")
      succeedsExpectation.fulfill()
    } catch {
      XCTFail("Should not fail!")
    }
    
    await fulfillment(of: [requestExpectation, succeedsExpectation], timeout: 1)
  }
  
  func testRegisterFails() async throws {
    let requestExpectation = self.expectation(description: "should make a network request")
    let failsExpectation = self.expectation(description: "should fail")
    
    let configuration = self.createMockSession(expectation: requestExpectation, shouldFail: true)
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = AuthModule(client: client)
    
    do {
      _ = try await module.login(email: "email", password: "password")
      XCTFail("Should not succeed!")
    } catch {
      failsExpectation.fulfill()
    }
    
    await fulfillment(of: [requestExpectation, failsExpectation], timeout: 1)
  }
}
