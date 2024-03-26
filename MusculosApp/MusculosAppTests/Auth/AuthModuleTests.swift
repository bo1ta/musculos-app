//
//  AuthModuleTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 26.03.2024.
//

import XCTest

@testable import MusculosApp

final class AuthModuleTests: XCTestCase {
  override class func tearDown() {
    MockURLProtocol.clear()
    super.tearDown()
  }
  
  private func setupNetworkConfiguration(shouldFail: Bool = false, expectation: XCTestExpectation? = nil) -> URLSessionConfiguration {
    MockURLProtocol.expectation = expectation
    MockURLProtocol.requestHandler = { request in
      guard !shouldFail, let url = request.url else { throw MusculosError.badRequest }
      
      let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
      let data = try XCTUnwrap(self.readFromFile(name: "authenticationResult"))
      return (response, data)
    }
    
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocol.self]
    return configuration
  }
  
  func testLoginSucceeds() async throws {
    let networkRequestExpectation = self.expectation(description: "should make a network request")
    let configuration = setupNetworkConfiguration(expectation: networkRequestExpectation)
    
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = AuthModule(client: client)

    let succeedsExpectation = self.expectation(description: "should succeed")
    
    do {
      let token = try await module.login(email: "email", password: "password")
      XCTAssertEqual(token, "secret-token")
      succeedsExpectation.fulfill()
    } catch {
      XCTFail("Should not fail!")
    }
    
    await fulfillment(of: [networkRequestExpectation, succeedsExpectation], timeout: 1)
  }
  
  func testLoginFails() async throws {
    let networkRequestExpectation = self.expectation(description: "should make a network request")
    let configuration = setupNetworkConfiguration(shouldFail: true, expectation: networkRequestExpectation)
    
    let failsExpectation = self.expectation(description: "should fail")
    
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = AuthModule(client: client)
    
    do {
      _ = try await module.login(email: "email", password: "password")
      XCTFail("Should not succeed!")
    } catch {
      failsExpectation.fulfill()
    }
    
    await fulfillment(of: [failsExpectation, networkRequestExpectation], timeout: 1)
  }
  
  func testRegisterSucceeds() async throws {
    let networkRequestExpectation = self.expectation(description: "should make a network request")
    let configuration = setupNetworkConfiguration(expectation: networkRequestExpectation)
    
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = AuthModule(client: client)
    
    let succeedsExpectation = self.expectation(description: "should succeed")
    
    do {
      let token = try await module.register(email: "email", password: "password", username: "username", fullName: "full name")
      XCTAssertEqual(token, "secret-token")
      succeedsExpectation.fulfill()
    } catch {
      XCTFail("Should not fail!")
    }
    
    await fulfillment(of: [networkRequestExpectation, succeedsExpectation], timeout: 1)
  }
  
  func testRegisterFails() async throws {
    let networkRequestExpectation = self.expectation(description: "should make a network request")
    let configuration = setupNetworkConfiguration(shouldFail: true, expectation: networkRequestExpectation)
    
    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = AuthModule(client: client)
    
    let failsExpectation = self.expectation(description: "should fail")
    
    do {
      _ = try await module.login(email: "email", password: "password")
      XCTFail("Should not succeed!")
    } catch {
      failsExpectation.fulfill()
    }
    
    await fulfillment(of: [networkRequestExpectation, failsExpectation], timeout: 1)
  }
}
