//
//  NSManagedObjectContext+StorageType.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import CoreData
import Foundation
import Utility

extension NSManagedObjectContext: StorageType {
  public var parentStorage: StorageType? {
    parent
  }

  public func allObjects<T: Object>(
    ofType type: T.Type,
    matching predicate: NSPredicate?,
    sortedBy descriptors: [NSSortDescriptor]?)
    -> [T]
  {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
    request.sortDescriptors = descriptors

    return loadObjects(ofType: type, with: request)
  }

  public func allObjects<T: Object>(
    ofType type: T.Type,
    matching predicate: NSPredicate?,
    relationshipKeyPathsForPrefetching: [String])
    -> [T]
  {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
    request.relationshipKeyPathsForPrefetching = relationshipKeyPathsForPrefetching

    return loadObjects(ofType: type, with: request)
  }

  public func allObjects<T: Object>(
    ofType type: T.Type,
    fetchLimit: Int,
    matching predicate: NSPredicate?,
    sortedBy descriptors: [NSSortDescriptor]?)
    -> [T]
  {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
    request.sortDescriptors = descriptors
    request.fetchLimit = fetchLimit

    return loadObjects(ofType: type, with: request)
  }

  public func countObjects(ofType type: (some Object).Type) -> Int {
    countObjects(ofType: type, matching: nil)
  }

  public func countObjects(ofType type: (some Object).Type, matching predicate: NSPredicate?) -> Int {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
    request.resultType = .countResultType

    var result = 0

    do {
      result = try count(for: request)
    } catch {
      Logger.error(error, message: "Unable to count objects")
    }

    return result
  }

  public func deleteObject(_ object: some Object) {
    guard let object = object as? NSManagedObject else {
      Logger.error(MusculosError.decodingError, message: "Cannot delete object! Invalid kind")
      return
    }

    delete(object)
  }

  func deleteAllObjects(ofType type: (some Object).Type) {
    let request = fetchRequest(forType: type)
    request.includesPropertyValues = false
    request.includesSubentities = false

    for object in loadObjects(ofType: type, with: request) {
      deleteObject(object)
    }
  }

  public func firstObject<T: Object>(of type: T.Type) -> T? {
    firstObject(of: type, matching: nil)
  }

  public func firstObject<T: Object>(of type: T.Type, matching predicate: NSPredicate?) -> T? {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
    request.fetchLimit = 1

    return loadObjects(ofType: type, with: request).first
  }

  public func insertNewObject<T: Object>(ofType _: T.Type) -> T {
    NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as! T // swiftlint:disable:this force_cast
  }

  public func loadObject<T: Object>(ofType _: T.Type, with objectID: T.ObjectID) -> T? {
    guard let objectID = objectID as? NSManagedObjectID else {
      Logger.error(
        MusculosError.unexpectedNil,
        message: "Cannot find objectID in context",
        properties: ["object_name": T.entityName])
      return nil
    }

    do {
      return try existingObject(with: objectID) as? T
    } catch {
      Logger.error(
        error,
        message: "Error loading object",
        properties: ["object_name": T.entityName])
    }

    return nil
  }

  public func findOrInsert<T: Object>(of type: T.Type, using predicate: NSPredicate) -> T {
    if let existingObject = firstObject(of: type, matching: predicate) {
      return existingObject
    }
    return insertNewObject(ofType: type)
  }

  public func saveIfNeeded() {
    guard hasChanges else {
      return
    }

    do {
      try save()
    } catch {
      rollback()
      Logger.error(
        error,
        message: "Failed to save context")
    }
  }

  public func fetchUniquePropertyValues(of type: (some Object).Type, property propertyToFetch: String) -> Set<UUID> {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.entityName)
    fetchRequest.resultType = .dictionaryResultType
    fetchRequest.propertiesToFetch = [propertyToFetch]

    do {
      guard let results = try fetch(fetchRequest) as? [[String: Any]] else {
        return []
      }
      return Set<UUID>(results.compactMap { dict in
        dict[propertyToFetch] as? UUID
      })
    } catch {
      Logger.error(
        error,
        message: "Cannot fetch by property",
        properties: [
          "property_name": propertyToFetch,
          "entity_name": type.entityName,
        ])
      return []
    }
  }

  /// Loads the collection of entities that match with a given Fetch Request
  ///
  private func loadObjects<T: Object>(ofType _: T.Type, with request: NSFetchRequest<NSFetchRequestResult>) -> [T] {
    var objects: [T]?

    do {
      objects = try fetch(request) as? [T]
    } catch {
      Logger.error(error, message: "Could not load objects")
    }
    return objects ?? []
  }

  /// Returns a NSFetchRequest instance with its *Entity Name* always set, for the specified Object Type.
  ///
  private func fetchRequest(forType type: (some Object).Type) -> NSFetchRequest<NSFetchRequestResult> {
    NSFetchRequest<NSFetchRequestResult>(entityName: type.entityName)
  }

  public func perform(_ block: @escaping () throws -> Void) async throws {
    try await withCheckedThrowingContinuation { [weak self] continuation in
      guard let self else {
        return
      }

      perform {
        do {
          try block()
          continuation.resume()
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }

  public func perform<ResultType>(_ block: @escaping () -> ResultType) async -> ResultType {
    await withCheckedContinuation { continuation in

      self.perform {
        let result = block()
        continuation.resume(returning: result)
      }
    }
  }

  public func createFetchedResultsController(
    for type: (some Object).Type,
    predicate: NSPredicate?,
    sortDescriptors: [NSSortDescriptor],
    fetchLimit: Int?,
    sectionNameKeyPath: String?,
    cacheName: String?)
    -> NSFetchedResultsController<NSFetchRequestResult>
  {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.entityName)
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.predicate = predicate

    if let fetchLimit {
      fetchRequest.fetchLimit = fetchLimit
    }

    return NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: self,
      sectionNameKeyPath: sectionNameKeyPath,
      cacheName: cacheName)
  }
}
