//
//  StorageOperations.swift
//  Storage
//
//  Created by Solomon Alexandru on 01.02.2025.
//

import CoreData
import Foundation

public typealias EntityType = Object & ReadOnlyConvertible

public typealias ReadStorageClosure<ResultType> = (StorageType) -> ResultType
public typealias WriteStorageClosure = (StorageType) throws -> Void

// MARK: - StorageOperations

public protocol StorageOperations {
  /// Perform a write operation. Uses `writerDerivedStorage`
  ///
  /// - Parameter writeClosure: A closure that performs the write operation on the provided `StorageType`.
  /// - Throws: An error if the write operation fails.
  ///
  func performWrite(_ writeClosure: @escaping WriteStorageClosure) async throws

  /// Perform a read operation. Uses `viewStorage`
  ///
  /// - Parameter readClosure: A closure that performs the read operation on the provided `StorageType`.
  /// - Returns: The result of the read operation.
  ///
  func performRead<ResultType>(_ readClosure: @escaping ReadStorageClosure<ResultType>) async -> ResultType

  /// Get the count of entities of the given type that match the optional predicate.
  ///
  /// - Parameters:
  ///   - type: The type of the entity to count.
  ///   - predicate: An optional `NSPredicate` to filter the entities.
  /// - Returns: The count of matching entities.
  ///
  func getObjectCount(_ type: (some Object).Type, predicate: NSPredicate?) async -> Int

  /// Get all entities of the given type that match the optional predicate.
  ///
  /// - Parameters:
  ///   - type: The type of the entity to fetch.
  ///   - predicate: An optional `NSPredicate` to filter the entities.
  /// - Returns: An array of read-only entities that match the criteria.
  ///
  func getAllEntities<T: EntityType>(_ type: T.Type, predicate: NSPredicate?) async -> [T.ReadOnlyType]

  /// Get all entities of the given type that match the optional predicate, with a fetch limit.
  ///
  /// - Parameters:
  ///   - type: The type of the entity to fetch.
  ///   - fetchLimit: The maximum number of entities to fetch.
  ///   - predicate: An optional `NSPredicate` to filter the entities.
  /// - Returns: An array of read-only entities that match the criteria, limited by the fetch limit.
  ///
  func getAllEntities<T: EntityType>(_ type: T.Type, fetchLimit: Int, predicate: NSPredicate?) async -> [T.ReadOnlyType]

  /// Get the first entity of the given type that matches the optional predicate.
  ///
  /// - Parameters:
  ///   - type: The type of the entity to fetch.
  ///   - predicate: An optional `NSPredicate` to filter the entities.
  /// - Returns: The first matching entity, or `nil` if no match is found.
  ///
  func getFirstEntity<T: EntityType>(_ type: T.Type, predicate: NSPredicate?) async -> T.ReadOnlyType?

  /// Create an `EntityPublisher` for the given entity type that matches the specified predicate.
  ///
  /// - Parameters:
  ///   - predicate: The `NSPredicate` used to filter the entities.
  /// - Returns: An `EntityPublisher` that publishes changes to the entities matching the predicate.
  ///
  func createEntityPublisher<T: EntityType>(matching predicate: NSPredicate) -> EntityPublisher<T>

  /// Create a `FetchedResultsPublisher` for the given entity type.
  ///
  /// - Parameters:
  ///   - predicate: An optional `NSPredicate` to filter the results.
  ///   - sortDescriptors: An array of `NSSortDescriptor` to sort the results.
  ///   - fetchLimit: An optional limit on the number of results to fetch.
  /// - Returns: A `FetchedResultsPublisher` that publishes changes to the fetched results.
  ///
  func createFetchedResultsPublisher<T: EntityType>(
    matching predicate: NSPredicate?,
    sortDescriptors: [NSSortDescriptor],
    fetchLimit: Int?) -> FetchedResultsPublisher<T>

  /// Update an entity in the storage with the given model.
  ///
  /// - Parameters:
  ///   - model: The model containing the updated data.
  ///   - type: The type of the entity to update.
  /// - Throws: An error if the update operation fails.
  ///
  func updateEntity<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) async throws

  /// Delete an entity from the storage that matches the given model.
  ///
  /// - Parameters:
  ///   - model: The model used to identify the entity to delete.
  ///   - type: The type of the entity to delete.
  /// - Throws: An error if the delete operation fails.
  ///
  func deleteEntity<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) async throws

  /// Import a single entity into the storage.
  ///
  /// - Parameters:
  ///   - model: The model containing the data to import.
  ///   - type: The type of the entity to import.
  /// - Throws: An error if the import operation fails.
  ///
  func importEntity<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) async throws

  /// Import multiple entities into the storage.
  ///
  /// - Parameters:
  ///   - models: An array of models containing the data to import.
  ///   - type: The type of the entities to import.
  /// - Throws: An error if the import operation fails.
  ///
  func importEntities<T: EntitySyncable>(_ models: [T.ModelType], of type: T.Type) async throws
}
