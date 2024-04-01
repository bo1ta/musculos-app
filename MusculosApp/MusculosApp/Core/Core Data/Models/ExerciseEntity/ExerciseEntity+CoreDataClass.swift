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
  
  static func predicateForId(_ id: UUID) -> NSPredicate {
    NSPredicate(format: "%K == %@", #keyPath(ExerciseEntity.exerciseId), id as NSUUID)
  }
}

extension ExerciseEntity: ReadOnlyConvertible {
   func update(with entity: Exercise) { }
}
