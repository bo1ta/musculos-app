//
//  UserDataStoreTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation
import XCTest
import Factory

@testable import MusculosApp

class UserDataStoreTests: XCTestCase {
  override func tearDown() {
    Container.shared.storageManager().reset()
    super.tearDown()
  }
  
  func testCreateUser() async throws {
    let person = PersonFactory.createPerson(username: "test_this")
    let dataStore = UserDataStore()
    try await dataStore.createUser(person: person)
    
    let currentPerson = await dataStore.loadCurrentPerson()
    XCTAssertEqual(person.username, currentPerson?.username)
  }
}
