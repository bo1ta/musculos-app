//
//  ExerciseEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.03.2024.
//
//

import Foundation
import CoreData

extension ExerciseEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
    return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
  }
  
  @NSManaged public var category: String?
  @NSManaged public var equipment: String?
  @NSManaged public var force: String?
  @NSManaged public var exerciseId: UUID?
  @NSManaged public var imageUrls: [String]?
  @NSManaged public var instructions: [String]?
  @NSManaged public var isFavorite: Bool
  @NSManaged public var level: String?
  @NSManaged public var name: String?
  @NSManaged public var primaryMuscles: [String]
  @NSManaged public var secondaryMuscles: [String]
  @NSManaged public var workouts: Set<WorkoutEntity>
  
}

extension ExerciseEntity : Identifiable {
  
}
