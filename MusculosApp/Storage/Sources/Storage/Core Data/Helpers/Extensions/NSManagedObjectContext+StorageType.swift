//
//  NSManagedObjectContext+StorageType.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import Foundation
import CoreData
import Utility

extension NSManagedObjectContext: StorageType {
  public func fetchUniquePropertyValues<T: Object, V: Hashable>(ofType type: T.Type, property propertyToFetch: String, expressionResultType: NSAttributeType) -> Set<V>? {
    let request = NSFetchRequest<NSDictionary>(entityName: type.entityName)
    request.resultType = .dictionaryResultType
    
    let expressionDescription = NSExpressionDescription()
    expressionDescription.name = "uniqueValues"
    expressionDescription.expression = NSExpression(forKeyPath: propertyToFetch)
    expressionDescription.expressionResultType = expressionResultType
    
    request.propertiesToFetch = [expressionDescription]
    request.returnsDistinctResults = true
    
    do {
      let results = try fetch(request)
      let uniqueValues = results.compactMap { $0["uniqueValues"] as? V }
      return Set(uniqueValues)
    } catch {
      print("Failed to fetch unique property values: \(error)")
      return nil
    }
  }
  
  public var parentStorage: StorageType? {
    return parent
  }
  
  public func allObjects<T: Object>(ofType type: T.Type, matching predicate: NSPredicate?, sortedBy descriptors: [NSSortDescriptor]?) -> [T] {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
    request.sortDescriptors = descriptors
    
    return loadObjects(ofType: type, with: request)
  }
  
  public func allObjects<T: Object>(ofType type: T.Type, matching predicate: NSPredicate?, relationshipKeyPathsForPrefetching: [String]) -> [T] {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
    request.relationshipKeyPathsForPrefetching = relationshipKeyPathsForPrefetching
    
    return loadObjects(ofType: type, with: request)
  }
  
  public func allObjects<T: Object>(ofType type: T.Type, fetchLimit: Int, matching predicate: NSPredicate?, sortedBy descriptors: [NSSortDescriptor]?) -> [T] {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
    request.sortDescriptors = descriptors
    request.fetchLimit = fetchLimit
    
    return loadObjects(ofType: type, with: request)
  }
  
  public func countObjects<T: Object>(ofType type: T.Type) -> Int {
    countObjects(ofType: type, matching: nil)
  }
  
  public func countObjects<T: Object>(ofType type: T.Type, matching predicate: NSPredicate?) -> Int {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
    request.resultType = .countResultType
    
    var result = 0
    
    do {
      result = try count(for: request)
    } catch {
      MusculosLogger.logError(error, message: "Unable to count objects", category: .coreData)
    }
    
    return result
  }
  
  public func deleteObject<T: Object>(_ object: T) {
    guard let object = object as? NSManagedObject else {
      MusculosLogger.logError(MusculosError.decodingError, message: "Cannot delete object! Invalid kind", category: .coreData)
      return
    }
    
    delete(object)
  }
  
  func deleteAllObjects<T: Object>(ofType type: T.Type) {
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
  
  public func insertNewObject<T: Object>(ofType type: T.Type) -> T {
    return NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as! T
  }
  
  public func loadObject<T: Object>(ofType type: T.Type, with objectID: T.ObjectID) -> T? {
    guard let objectID = objectID as? NSManagedObjectID else {
      MusculosLogger.logError(
        MusculosError.notFound,
        message: "Cannot find objectID in context",
        category: .coreData,
        properties: ["object_name": T.entityName]
      )
      return nil
    }
    
    do {
      return try existingObject(with: objectID) as? T
    } catch {
      MusculosLogger.logError(
        error,
        message: "Error loading object",
        category: .coreData,
        properties: ["object_name": T.entityName]
      )
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
    guard hasChanges else { return }
    
    do {
      try save()
    } catch {
      rollback()
      MusculosLogger.logError(error, message: "Failed to save context", category: .coreData)
    }
  }
  
  func fetchUniquePropertyValues(forEntity entityName: String, property propertyToFetch: String) -> Set<UUID>? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    fetchRequest.resultType = .dictionaryResultType
    fetchRequest.propertiesToFetch = [propertyToFetch]
    
    do {
      guard let results = try self.fetch(fetchRequest) as? [[String: Any]] else { return nil }
      return Set<UUID>(results.compactMap({ dict in
        return dict[propertyToFetch] as? UUID
      }))
    } catch {
      MusculosLogger.logError(error, message: "Cannot fetch by property", category: .coreData, properties: ["property_name": propertyToFetch, "entity_name": entityName])
      return nil
    }
  }
  
  /// Loads the collection of entities that match with a given Fetch Request
  ///
  private func loadObjects<T: Object>(ofType type: T.Type, with request: NSFetchRequest<NSFetchRequestResult>) -> [T] {
    var objects: [T]?
    
    performAndWait { [weak self] in
      guard let self else { return }
      
      do {
        objects = try self.fetch(request) as? [T]
      } catch {
        MusculosLogger.logError(error, message: "Could not load objects", category: .coreData)
      }
    }
    return objects ?? []
  }
  
  /// Returns a NSFetchRequest instance with its *Entity Name* always set, for the specified Object Type.
  ///
  private func fetchRequest<T: Object>(forType type: T.Type) -> NSFetchRequest<NSFetchRequestResult> {
    return NSFetchRequest<NSFetchRequestResult>(entityName: type.entityName)
  }
  
  public func perform(_ block: @escaping () throws -> Void) async throws {
    return try await withCheckedThrowingContinuation { [weak self] continuation in
      guard let self else { return }
      
      self.performAndWait {
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
    return try await withCheckedContinuation { continuation in
      
      self.perform {
        let result = block()
        continuation.resume(returning: result)
      }
    }
  }
}
