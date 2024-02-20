//
//  DataImporter.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.02.2024.
//

import Foundation
import CoreData

class DataImporter {
  private let context: NSManagedObjectContext

  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  public func importData<T: NSManagedObject & Decodable>(_ data: Data, as model: T.Type) async {
    await context.perform { [unowned self] in
      let decoder = JSONDecoder()
      decoder.userInfo[.managedObjectContext] = self.context
      
      do {
        _ = try decoder.decode(model, from: data)
        try self.context.save()
      } catch {
        if self.context.hasChanges {
          self.context.rollback()
        }
        MusculosLogger.logError(error: error, message: "Failed to import data", category: .coreData)
      }
    }
  }
}
