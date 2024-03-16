//
//  ExerciseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.02.2024.
//

import Foundation
import CoreData

class ExerciseDataStore: BaseDataStore {
  func fetchExercises(limit: Int = 5, offset: Int = 0) throws -> [Exercise] {
    let fetchRequest = Exercise.fetchRequest()
    fetchRequest.fetchLimit = limit
    fetchRequest.fetchOffset = offset
    return try mainContext.fetch(fetchRequest)
  }
  
  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) async {
    await writeOnlyContext.perform { [ weak self] in
      guard let self else { return }
  
      if let newExercise = self.maybeSwitchContextFor(exercise, to: writeOnlyContext) {
        newExercise.isFavorite = isFavorite
      }
    }

    await writeOnlyContext.saveIfNeeded()
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
  
  public func importExercisesUsingData(_ data: Data) async -> [Exercise] {
    guard let entries = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return [] }
    
    var exercises: [Exercise] = []
    
    await writeOnlyContext.perform { [weak self] in
      guard let self else { return }
      
      for entry in entries {
        let uuid = UUID(uuidString: entry["id"] as! String)!
        let exercise = Exercise.findOrInsert(using: uuid, in: self.writeOnlyContext)
        
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
        
        exercises.append(exercise)
      }
    }
    
    await writeOnlyContext.saveIfNeeded()
    
    // change to main context so exercises can be read
    let newExercises = prepareExercisesForMainContext(exercises)
    await mainContext.saveIfNeeded()
    
    return newExercises
  }
  
  private func prepareExercisesForMainContext(_ exercises: [Exercise]) -> [Exercise] {
    return exercises.compactMap { maybeSwitchContextFor($0, to: mainContext) }
  }
  
  private func maybeSwitchContextFor(_ exercise: Exercise, to context: NSManagedObjectContext) -> Exercise? {
    guard exercise.managedObjectContext != context else { return exercise }
    return exercise.toContext(context)
  }
}
