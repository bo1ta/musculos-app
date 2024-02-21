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
  
  public func importExercisesUsingData(_ data: Data) -> [Exercise] {
    guard let entries = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return [] }
    
    var exercises: [Exercise] = []
    
    entries.forEach { entry in
      let uuid = UUID(uuidString: entry["id"] as! String)!
      let exercise = Exercise.findOrInsert(using: uuid, in: self.context)
      
      if exercise.objectID.isTemporaryID || exercise.synchronizationState == .notSynchronized {
        exercise.id = uuid
        exercise.name = entry["name"] as! String
        exercise.equipment = entry["equipment"] as? String
        exercise.instructions = entry["instructions"] as! [String]
        exercise.primaryMuscles = entry["primary_muscles"] as! [String]
        exercise.secondaryMuscles = entry["secondary_muscles"] as! [String]
        exercise.category = entry["category"] as! String
        exercise.force = entry["force"] as? String
        exercise.imageUrls = entry["image_urls"] as! [String]
        exercise.level = entry["level"] as! String
//        exercise.synchronizationState = .synchronizationPending
      } else {
        // we have local changes, don't update
      }
      exercises.append(exercise)
    }

    return exercises
  }
}
