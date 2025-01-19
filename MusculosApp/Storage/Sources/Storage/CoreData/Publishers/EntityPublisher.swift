//
//  EntityPublisher.swift
//  Storage
//
//  Created by Solomon Alexandru on 14.01.2025.
//

import Combine
import CoreData
import Foundation
import Utility

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
      let updated = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
      let inserted = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? []
      return updated.union(inserted)
    }
    .compactMap { objectSet -> T? in
      guard let firstObject = objectSet.first as? T else {
        Logger.info(message: "No valid objects found of type \(T.self)")
        return nil
      }
      return firstObject
    }
    .map { $0.toReadOnly() }
    .eraseToAnyPublisher()
  }
}
