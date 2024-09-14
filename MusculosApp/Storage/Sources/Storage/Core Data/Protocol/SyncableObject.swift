//
//  SyncableObject.swift
//
//
//  Created by Solomon Alexandru on 14.09.2024.
//

import CoreData

/// Helper protocol that handles the data synchronization between Codable data and a Core Data store entity
///
public protocol SyncableObject: Codable {
  associatedtype EntityType: NSManagedObject & EntityPopulatable where EntityType.ModelType == Self

  /// The value used for fetching the first entity, if it exists
  ///
  var identifierValue: String { get }

  /// The attribute key used for identifying the first entity, if it exists
  ///
  static var identifierKey: String { get }

  /// Decodes the `Data` object and imports it into the data store, or updates the first found entity matching `identifierValue`
  ///
  static func createWithTaskFrom(_ data: Data) async throws -> Self

  /// Decodes the `Data` object that holds multiple codable objects. Imports the results or updates if needed
  /// 
  static func createArrayWithTaskFrom(_ data: Data) async throws -> [Self]
}

public extension SyncableObject {
  private static func handleObjectSync(_ object: Self, with storage: StorageType) throws {
      let predicate = NSPredicate(format: "%K == %@", Self.identifierKey, object.identifierValue)
      if let existingEntity = storage.firstObject(of: EntityType.self, matching: predicate) {
          existingEntity.updateEntity(from: object, using: storage)
      } else {
          let newEntity = storage.insertNewObject(ofType: EntityType.self)
          newEntity.populateEntity(from: object, using: storage)
      }
  }

  static func createWithTaskFrom(_ data: Data) async throws -> Self {
      let decoder = JSONDecoder()
      let object = try decoder.decode(Self.self, from: data)
      try await StorageManager.shared.performWrite { storage in
          try handleObjectSync(object, with: storage)
      }
      return object
  }

  static func createArrayWithTaskFrom(_ data: Data) async throws -> [Self] {
      let decoder = JSONDecoder()
      let objects = try decoder.decode([Self].self, from: data)
      try await StorageManager.shared.performWrite { storage in
          for object in objects {
              try handleObjectSync(object, with: storage)
          }
      }
      return objects
  }
}
