//
//  NSManagedObjectContext+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.09.2023.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
  func fetchAllEntities<T: NSManagedObject>() async throws -> [T]? {
    let request = NSFetchRequest<T>(entityName: String(describing: self))
    return try self.fetch(request)
  }

  func fetchEntitiesByIds<T: NSManagedObject>(entityName: String, by ids: [Int]) async throws -> [T]? {
    let request = NSFetchRequest<T>(entityName: entityName)
    let predicate = NSPredicate(format: "id IN %@", ids)
    request.predicate = predicate
    return try fetch(request)
  }
  
  func saveContext() {
    performAndWait { [weak self] in
      guard let self, self.hasChanges else { return }

      do {
        try save()
      } catch {
        self.rollback()
        MusculosLogger.logError(error: error, message: "Failed to save context", category: .coreData)
      }
    }
  }
}
