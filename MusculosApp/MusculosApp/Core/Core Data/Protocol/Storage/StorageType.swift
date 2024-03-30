//
//  StorageType.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import Foundation
import CoreData

protocol StorageType {
  var parentStorage: StorageType? { get }
  
  /// Returns all of the available objects given a Type
  /// Matching the predicate and sorted with a given collection (if needed)
  ///
  func allObjects<T: Object>(ofType type: T.Type, matching predicate: NSPredicate?, sortedBy descriptors: [NSSortDescriptor]?) -> [T]
  
  /// Returns objects with a given limit count
  ///
  func allObjects<T: Object>(ofType type: T.Type, fetchLimit: Int, matching predicate: NSPredicate?, sortedBy descriptors: [NSSortDescriptor]?) -> [T]
  
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
  
  /// Saves changes, if needed
  ///
  func saveIfNeeded()
  
  /// Perform sync block
  ///
  func perform(_ closure: @escaping () -> Void) async
  
  /// Perform block and saves changes
  ///
  func performAndSave(_ block: @escaping () -> Void) async
  
  /// Create an `NSFetchedResultsController` using this `StorageType`
  ///
  func createFetchedResultsController<ResultType>(fetchRequest: NSFetchRequest<ResultType>, sectionNameKeyPath: String?, cacheName: String?) -> NSFetchedResultsController<ResultType>
}
