//
//  UserDataStoreTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation
import XCTest

@testable import MusculosApp

class UserDataStoreTests: XCTestCase {
  func testCreateUser() async throws {
    let person = PersonFactory.createPerson(username: "test_this")
    let dataStore = UserDataStore()
    try await dataStore.createUser(person: person)
    
    let currentPerson = await dataStore.loadCurrentPerson()
    XCTAssertEqual(person.username, currentPerson?.username)
  }
}
