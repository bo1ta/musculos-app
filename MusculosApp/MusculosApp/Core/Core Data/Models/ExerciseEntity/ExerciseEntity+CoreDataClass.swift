//
//  ExerciseEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.03.2024.
//
//

import Foundation
import CoreData

@objc(ExerciseEntity)
public class ExerciseEntity: NSManagedObject {
  func toReadOnly() -> Exercise {
    return Exercise(category: self.category ?? "",
                    equipment: self.equipment,
                    id: self.exerciseId,
                    level: self.level!,
                    name: self.name!,
                    primaryMuscles: self.primaryMuscles,
                    secondaryMuscles: self.secondaryMuscles,
                    instructions: self.instructions!,
                    imageUrls: self.imageUrls!
    )
  }
}

extension ExerciseEntity: ReadOnlyConvertible {
   func update(with entity: Exercise) { }
}

// MARK: - Common Predicate

extension ExerciseEntity {
  enum CommonPredicate {
    case byId(UUID)
    case all
    case isFavorite
    
    var nsPredicate: NSPredicate? {
      switch self {
      case .byId(let uuid):
        return NSPredicate(format: "%K == %@", #keyPath(ExerciseEntity.exerciseId), uuid as NSUUID)
      case .all:
        return nil
      case .isFavorite:
        return NSPredicate(format: "%K == true", #keyPath(ExerciseEntity.isFavorite))
      }
    }
  }
}
