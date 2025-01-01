//
//  StorageType.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import CoreData
import Foundation

public protocol StorageType {
  var parentStorage: StorageType? { get }

  /// Returns all of the available objects given a Type
  /// Matching the predicate and sorted with a given collection (if needed)
  ///
  func allObjects<T: Object>(ofType type: T.Type, matching predicate: NSPredicate?, sortedBy descriptors: [NSSortDescriptor]?)
    -> [T]

  /// Returns all of the available objects given a Type
  /// Matching the predicate and prefetching a given key path
  ///
  func allObjects<T: Object>(ofType type: T.Type, matching predicate: NSPredicate?, relationshipKeyPathsForPrefetching: [String])
    -> [T]

  /// Returns objects with a given limit count
  ///
  func allObjects<T: Object>(
    ofType type: T.Type,
    fetchLimit: Int,
    matching predicate: NSPredicate?,
    sortedBy descriptors: [NSSortDescriptor]?) -> [T]

  /// Returns the count of all available objects, given a Type
  ///
  func countObjects<T: Object>(ofType type: T.Type) -> Int

  /// Returns the count of all available objects, given a Type
  /// Matching a predicate
  ///
  func countObjects<T: Object>(ofType type: T.Type, matching predicate: NSPredicate?) -> Int

  /// Deletes the specified object
  ///
  func deleteObject<T: Object>(_ object: T)

  /// Returns the first available object, given a Type
  ///
  func firstObject<T: Object>(of type: T.Type) -> T?

  /// Returns the first available object, given a Type
  /// Matching a predicate
  ///
  func firstObject<T: Object>(of type: T.Type, matching predicate: NSPredicate?) -> T?

  /// Finds or inserts object from a identifier, given a Type
  ///
  func findOrInsert<T: Object>(of type: T.Type, using predicate: NSPredicate) -> T

  /// Inserts a new object of a given type
  ///
  func insertNewObject<T: Object>(ofType type: T.Type) -> T

  /// Loads an object, of the specified Type, with a given ObjectID (if any)
  ///
  func loadObject<T: Object>(ofType type: T.Type, with objectID: T.ObjectID) -> T?

  /// Returns a set of a unique property values for a given type.
  ///
  func fetchUniquePropertyValues<T: Object>(of type: T.Type, property propertyToFetch: String) -> Set<UUID>

  /// Saves context, if it has changes
  ///
  func saveIfNeeded()

  /// Perform and wait. Mirrors the `NSManagedObjectContext.performAndWait`
  ///
  func performAndWait(_ block: () -> Void)

  /// Perform the block. Mirros the `NSManagedObjectContext.perform`
  ///
  func perform(_ block: @escaping () -> Void)

  /// Perform the block the async way, returning the block results.
  ///
  func perform<ResultType>(_ block: @escaping () -> ResultType) async -> ResultType

  /// Perform the block the async way.
  ///
  func perform(_ block: @escaping () throws -> Void) async throws

  /// Create a fetched results controller for the given type
  ///
  func createFetchedResultsController<ResultType>(
    fetchRequest: NSFetchRequest<ResultType>,
    sectionNameKeyPath: String?,
    cacheName: String?) -> NSFetchedResultsController<ResultType>
}
