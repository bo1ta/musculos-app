//
//  ExerciseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.02.2024.
//

import Foundation
import CoreData

class ExerciseDataStore {
  private let mainContext = CoreDataStack.shared.mainContext
  private let privateContext = CoreDataStack.shared.syncPrivateContext
  
  func fetchExercises(limit: Int = 5, offset: Int = 0) throws -> [Exercise] {
    let fetchRequest = Exercise.fetchRequest()
    fetchRequest.fetchLimit = limit
    fetchRequest.fetchOffset = offset
    return try mainContext.fetch(fetchRequest)
  }
  
  func saveLocalChanges() {
    privateContext.saveContext()
  }
  
  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) async {
    await privateContext.perform { [ weak self] in
      guard let self else { return }
  
      if let newExercise = self.maybeSwitchContext(exercise, to: self.privateContext) {
        newExercise.isFavorite = isFavorite
        privateContext.saveContext()
      }
    }
  }
  
  func fetchFavoriteExercises() throws -> [Exercise] {
    let fetchRequest = Exercise.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
    return try mainContext.fetch(fetchRequest)
  }
  
  func fetchExercisesByMuscle(_ muscle: String) throws -> [Exercise] {
    let fetchRequest = Exercise.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "ANY primaryMuscles CONTAINS[c] %@ OR ANY secondaryMuscles CONTAINS[c] %@", muscle, muscle)
    return try mainContext.fetch(fetchRequest)
  }
  
  public func importExercisesUsingData(_ data: Data, prepareForViewContext: Bool = false) -> [Exercise] {
    guard let entries = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return [] }
    
    var exercises: [Exercise] = []
    
    privateContext.performAndWait { [weak self] in
      guard let self else { return }
      
      for entry in entries {
        let uuid = UUID(uuidString: entry["id"] as! String)!
        let exercise = Exercise.findOrInsert(using: uuid, in: self.privateContext)
        
        if exercise.objectID.isTemporaryID {
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
        } else {
          // we already have local changes, no need to update
        }
        
        self.privateContext.saveContext()
        
        // switch context
        if let newExercise = self.maybeSwitchContext(exercise, to: self.mainContext) {
          exercises.append(newExercise)
        }
      }
    }

    // save the parent context so exercises persist
    mainContext.saveContext()

    return exercises
  }
  
  private func maybeSwitchContext(_ exercise: Exercise, to context: NSManagedObjectContext) -> Exercise? {
    guard exercise.managedObjectContext != context else { return exercise }
    return exercise.toContext(context)
  }
}
