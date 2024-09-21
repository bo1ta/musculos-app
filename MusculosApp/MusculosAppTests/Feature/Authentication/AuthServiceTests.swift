//
//  AuthServiceTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 26.03.2024.
//

import XCTest
import Factory

@testable import MusculosApp

//final class AuthServiceTests: XCTestCase, MusculosTestBase {
//  override func tearDown() {
//    MockURLProtocol.clear()
//    Container.shared.reset()
//    super.tearDown()
//  }
//  
//  func testLoginSucceeds() async throws {
//    let requestExpectation = self.expectation(description: "should make a network request")
//    let configuration = self.createMockSession(jsonFileName: "authenticationResult", expectation: requestExpectation)
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//
//    Container.shared.client.register { client }
//
//    let service = AuthService()
//    let session = try await service.login(email: "email", password: "password")
//    XCTAssertEqual(session.authToken, "secret-token")
//    await fulfillment(of: [requestExpectation], timeout: 1)
//  }
//  
//  func testLoginFails() async throws {
//    let requestExpectation = self.expectation(description: "should make a network request")
//    let failsExpectation = self.expectation(description: "should fail")
//
//    let configuration = self.createMockSession(expectation: requestExpectation, shouldFail: true)
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//
//    Container.shared.client.register { client }
//
//    let module = AuthService()
//    do {
//      _ = try await module.login(email: "email", password: "password")
//      XCTFail("Should not succeed!")
//    } catch {
//      failsExpectation.fulfill()
//    }
//    
//    await fulfillment(of: [failsExpectation, requestExpectation], timeout: 1)
//  }
//  
//  func testRegisterSucceeds() async throws {
//    let requestExpectation = self.expectation(description: "should make a network request")
//    let configuration = self.createMockSession(jsonFileName: "authenticationResult", expectation: requestExpectation)
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//
//    Container.shared.client.register { client }
//
//    let module = AuthService()
//    let session =  try await module.register(email: "email", password: "password", username: "username")
//    XCTAssertEqual(session.authToken, "secret-token")
//    await fulfillment(of: [requestExpectation], timeout: 1)
//  }
//  
//  func testRegisterFails() async throws {
//    let requestExpectation = self.expectation(description: "should make a network request")
//    let failsExpectation = self.expectation(description: "should fail")
//    
//    let configuration = self.createMockSession(expectation: requestExpectation, shouldFail: true)
//    let urlSession = URLSession(configuration: configuration)
//    let client = MusculosClient(urlSession: urlSession)
//
//    Container.shared.client.register { client }
//
//    let module = AuthService()
//    do {
//      _ = try await module.login(email: "email", password: "password")
//      XCTFail("Should not succeed!")
//    } catch {
//      failsExpectation.fulfill()
//    }
//    
//    await fulfillment(of: [requestExpectation, failsExpectation], timeout: 1)
//  }
//}
