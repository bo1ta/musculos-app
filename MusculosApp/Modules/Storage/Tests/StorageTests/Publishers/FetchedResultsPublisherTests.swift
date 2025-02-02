//
//  FetchedResultsPublisherTests.swift
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

public class FetchedResultsPublisherTests: XCTestCase, MusculosTestBase {
  @Injected(\StorageContainer.storageManager) var storageManager
  private var cancellables: Set<AnyCancellable> = []

  func testPublishesDidInsertModelEvent() async {
    let fetchedResultsPublisher = FetchedResultsPublisher<GoalEntity>(storage: storageManager.viewStorage, sortDescriptors: [])

    let expectation = self.expectation(description: "should send didInsertModel event")
    fetchedResultsPublisher.publisher
      .sink { event in
        guard case .didInsertModel = event else {
          XCTFail("Unexpected event")
          return
        }
        expectation.fulfill()
      }
      .store(in: &cancellables)

    _ = GoalFactory.createGoal()

    await fulfillment(of: [expectation], timeout: 5)
    clearStorage()
  }

  func testPublishesDidUpdateModelEvent() async throws {
    let exercise = ExerciseFactory.createExercise()

    let fetchedResultsPublisher = FetchedResultsPublisher<ExerciseEntity>(
      storage: storageManager.viewStorage,
      sortDescriptors: [])
    XCTAssertEqual(fetchedResultsPublisher.fetchedObjects.count, 1)

    let expectation = self.expectation(description: "should send didUpdateModel event")
    fetchedResultsPublisher.publisher
      .sink { event in
        guard case .didUpdateModel = event else {
          XCTFail("Unexpected event")
          return
        }
        expectation.fulfill()
      }
      .store(in: &cancellables)

    try await ExerciseDataStore().favoriteExercise(exercise, isFavorite: true)

    await fulfillment(of: [expectation], timeout: 5)
    clearStorage()
  }

  func testPublishesDidUpdateContentEvent() async throws {
    _ = ExerciseFactory.createExercise()
    _ = ExerciseFactory.createExercise()
    _ = ExerciseFactory.createExercise(isFavorite: true)

    let fetchedResultsPublisher = FetchedResultsPublisher<ExerciseEntity>(
      storage: storageManager.viewStorage,
      sortDescriptors: [])
    XCTAssertEqual(fetchedResultsPublisher.fetchedObjects.count, 3)

    let expectation = self.expectation(description: "should send didUpdateContent event")
    fetchedResultsPublisher.publisher
      .sink { event in
        guard case .didUpdateContent = event else {
          XCTFail("Unexpected event")
          return
        }
        expectation.fulfill()
      }
      .store(in: &cancellables)

    fetchedResultsPublisher.predicate = \ExerciseEntity.isFavorite == true

    await fulfillment(of: [expectation], timeout: 5)
    clearStorage()
  }

  func testPublishesDidDeleteModelEvent() async throws {
    let exercise = ExerciseFactory.createExercise()
    _ = ExerciseFactory.createExercise()

    let fetchedResultsPublisher = FetchedResultsPublisher<ExerciseEntity>(
      storage: storageManager.viewStorage,
      sortDescriptors: [])
    XCTAssertEqual(fetchedResultsPublisher.fetchedObjects.count, 2)

    let expectation = self.expectation(description: "should send didUpdateContent event")
    fetchedResultsPublisher.publisher
      .sink { event in
        guard case .didDeleteModel = event else {
          XCTFail("Unexpected event")
          return
        }
        expectation.fulfill()
      }
      .store(in: &cancellables)

    try await storageManager.deleteEntity(exercise, of: ExerciseEntity.self)

    await fulfillment(of: [expectation], timeout: 5)
    clearStorage()
  }
}
