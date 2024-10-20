//
//  SyncableObject.swift
//
//
//  Created by Solomon Alexandru on 14.09.2024.
//

import CoreData
import Utility
import Factory

/// Helper protocol that handles the data synchronization between Codable data and a Core Data store entity
///
public protocol SyncableObject: Codable {
  associatedtype EntityType: EntitySyncable & NSManagedObject where EntityType.ModelType == Self

  /// The value used for finding the first entity, if it exists
  ///
  var identifierValue: String { get }

  /// The attribute key used for filtering for the first entity, if it exists
  ///
  static var identifierKey: String { get }
}

extension SyncableObject {
  /// Decodes the `Data` object that holds multiple codable objects. Imports the results or updates if needed
  ///
  public static func createWithTaskFrom(_ data: Data) async throws -> Self {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    do {
      let object = try decoder.decode(Self.self, from: data)

      do {
        try await Self.storageManager.performWrite { storage in
          try handleObjectSync(object, with: storage)
        }
      } catch {
        MusculosLogger.logError(error, message: "Could not write object", category: .coreData, properties: ["object_name": object.self])
        throw StorageError.syncingFailed(error.localizedDescription)
      }
      return object
    } catch {
      MusculosLogger.logError(error, message: "Could not decode object", category: .decoderError, properties: ["json": String(data: data, encoding: .utf8)])
      throw MusculosError.decodingError
    }

  }

  /// Decodes the `Data` object that holds multiple codable objects. Imports the results or updates if needed
  ///
  public static func createArrayWithTaskFrom(_ data: Data) async throws -> [Self] {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    let objects = try decoder.decode([Self].self, from: data)

    try await Self.storageManager.performWrite { storage in
      for object in objects {
        try handleObjectSync(object, with: storage)
      }
    }
    return objects
  }

  private static func handleObjectSync(_ object: Self, with storage: StorageType) throws {
    let predicate = NSPredicate(format: "%K == %@", Self.identifierKey, object.identifierValue)
    if let existingEntity = storage.firstObject(of: EntityType.self, matching: predicate) {
      try existingEntity.updateEntityFrom(object, using: storage)
    } else {
      let newEntity = storage.insertNewObject(ofType: EntityType.self)
      try newEntity.populateEntityFrom(object, using: storage)
    }
  }

  private static var storageManager: StorageManagerType {
    return StorageContainer.shared.storageManager()
  }
}
