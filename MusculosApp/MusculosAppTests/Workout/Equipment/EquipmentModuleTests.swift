//
//  EquipmentModuleTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import Foundation
import XCTest
@testable import MusculosApp

class EquipmentModuleTests: XCTestCase {
  override class func tearDown() {
    MockURLProtocol.clear()
    super.tearDown()
  }

  func testGetAllEquipmentSucceeds() async throws {
    MockURLProtocol.requestHandler = { request in
      guard let url = request.url else { throw MusculosError.badRequest }

      let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
      let data = try XCTUnwrap(self.readFromFile(name: "getEquipment"))
      return (response, data)
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

  func testGetAllEquipmentFails() async throws {
    MockURLProtocol.requestHandler = { _ in throw MusculosError.badRequest }
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocol.self]

    let urlSession = URLSession(configuration: configuration)
    let client = MusculosClient(urlSession: urlSession)
    let module = EquipmentModule(client: client)

    do {
      _ = try await module.getAllEquipment()
    } catch {
      let nsError = error as NSError
      XCTAssertEqual(nsError.domain, "MusculosApp.MusculosError")
    }
  }
}
