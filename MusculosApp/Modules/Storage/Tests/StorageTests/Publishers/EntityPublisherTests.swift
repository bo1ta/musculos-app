//
//  EntityPublisherTests.swift
//  Storage
//
//  Created by Solomon Alexandru on 02.02.2025.
//

import Combine
import Factory
import Foundation
import Principle
import XCTest
@testable import Storage

public class EntityPublisherTests: XCTestCase, MusculosTestBase {
  @Injected(\StorageContainer.storageManager) var storageManager
  private var cancellables: Set<AnyCancellable> = []

  func testPublisherEmitsValues() async throws {
    let user = UserProfileFactory.createUser()
    let entityPublisher = EntityPublisher<UserProfileEntity>(
      storage: storageManager.writerDerivedStorage,
      predicate: \UserProfileEntity.uniqueID == user.id)

    let expectation = self.expectation(description: "should update user")

    entityPublisher.publisher
      .sink { _ in
        expectation.fulfill()
      }
      .store(in: &cancellables)

    try await UserDataStore().updateProfile(userId: user.id, weight: 20.0)

    await fulfillment(of: [expectation], timeout: 5)

    clearStorage()
  }
}
