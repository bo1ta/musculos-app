//
//  BaseFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Fakery
import Queue

public class BaseFactory: @unchecked Sendable {
  let faker = Faker()
  let backgroundWorker = AsyncQueue()

  var dataStore: CoreDataStore {
    StorageContainer.shared.coreDataStore()
  }

  func syncObject<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) {
    backgroundWorker.addOperation(priority: .high) { [weak self] in
      try await self?.dataStore.importModel(model, of: type)
    }
  }

  func awaitPendingOperations() async {
    await backgroundWorker.addBarrierOperation(operation: { }).value
  }
}
