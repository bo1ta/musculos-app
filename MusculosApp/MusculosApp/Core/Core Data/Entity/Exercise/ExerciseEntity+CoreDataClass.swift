//
//  ExerciseEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.02.2024.
//
//

import Foundation
import CoreData

@objc(ExerciseEntity)
public class ExerciseEntity: NSManagedObject {
  @NSManaged public var id: UUID?
  @NSManaged public var force: String?
  @NSManaged public var level: String?
  @NSManaged public var equipment: String?
  @NSManaged public var category: String?
  @NSManaged public var name: String?
  @NSManaged public var primaryMuscles: NSSet?
  @NSManaged public var secondaryMuscles: NSSet?
  @NSManaged public var instructions: NSOrderedSet?

  enum CodingKeys: String, CodingKey {
    case id, force, level, equipment, category, name, instruction
    case primaryMuscles = "primary_muscles"
    case secondaryMuscles = "secondary_muscles"
  }
  
//  public required convenience init(from decoder: Decoder) throws {
//    guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
//      throw MusculosError.decodingError
//    }
//  }
}
