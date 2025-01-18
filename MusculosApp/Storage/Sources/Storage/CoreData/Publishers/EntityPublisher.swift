//
//  EntityPublisher.swift
//  Storage
//
//  Created by Solomon Alexandru on 14.01.2025.
//

import Combine
import CoreData
import Foundation

public class EntityPublisher<T: EntityType> {
  private let storage: StorageType
  private let predicate: NSPredicate

  public let publisher: AnyPublisher<T.ReadOnlyType?, Never>

  public init(storage: StorageType, predicate: NSPredicate) {
    self.storage = storage
    self.predicate = predicate

    publisher = NotificationCenter.default.publisher(
      for: .NSManagedObjectContextObjectsDidChange,
      object: storage as? NSManagedObjectContext)
      .map { notification -> Set<NSManagedObject> in
        let updatedObjects = (notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>) ?? []
        let insertedObjects = (notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>) ?? []
        return updatedObjects.union(insertedObjects)
      }
      .compactMap { $0 as? T }
      .first { predicate.evaluate(with: $0) }
      .map { $0.toReadOnly() }
      .eraseToAnyPublisher()
  }
}
