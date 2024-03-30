//
//  NSManagedObjectContext+Storage.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import Foundation
import CoreData

extension NSManagedObjectContext: StorageType {
  var parentStorage: StorageType? {
    return parent
  }
  
  func allObjects<T: Object>(ofType type: T.Type, matching predicate: NSPredicate?, sortedBy descriptors: [NSSortDescriptor]?) -> [T] {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
//    request.sortDescriptors = descriptors
    
    return loadObjects(ofType: type, with: request)
  }
  
  func allObjects<T: Object>(ofType type: T.Type, fetchLimit: Int, matching predicate: NSPredicate?, sortedBy descriptors: [NSSortDescriptor]?) -> [T] {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
//    request.sortDescriptors = descriptors
    request.fetchLimit = fetchLimit
    
    return loadObjects(ofType: type, with: request)
  }
  
  func countObjects<T: Object>(ofType type: T.Type) -> Int {
    countObjects(ofType: type, matching: nil)
  }
  
  func countObjects<T: Object>(ofType type: T.Type, matching predicate: NSPredicate?) -> Int {
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
  
  func deleteObject<T: Object>(_ object: T) {
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
  
  func firstObject<T: Object>(of type: T.Type) -> T? {
    firstObject(of: type, matching: nil)
  }
  
  func firstObject<T: Object>(of type: T.Type, matching predicate: NSPredicate?) -> T? {
    let request = fetchRequest(forType: type)
    request.predicate = predicate
    request.fetchLimit = 1
    
    return loadObjects(ofType: type, with: request).first
  }
  
  func insertNewObject<T: Object>(ofType type: T.Type) -> T {
    return NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as! T
  }
  
  func loadObject<T: Object>(ofType type: T.Type, with objectID: T.ObjectID) -> T? {
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
  
  func findOrInsert<T: Object>(of type: T.Type, using predicate: NSPredicate) -> T {
    if let existingObject = firstObject(of: type, matching: predicate) {
      return existingObject
    }
    return insertNewObject(ofType: type)
  }
  
  func performAndSave(_ closure: @escaping () -> Void) async {
    await perform { [weak self] in
      closure()
      self?.saveIfNeeded()
    }
  }
  
  func saveIfNeeded() {
    guard hasChanges else { return }
    
    do {
      try save()
    } catch {
      rollback()
      MusculosLogger.logError(error, message: "Failed to save context", category: .coreData)
    }
  }
  
  func createFetchedResultsController<ResultType>(fetchRequest: NSFetchRequest<ResultType>, sectionNameKeyPath: String?, cacheName: String?) -> NSFetchedResultsController<ResultType> {
    return NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: self,
      sectionNameKeyPath: sectionNameKeyPath,
      cacheName: cacheName
    )
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
}
