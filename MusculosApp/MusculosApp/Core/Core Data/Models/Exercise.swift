//
//  Exercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//
//

import Foundation
import CoreData

@objc(Exercise)
public class Exercise: NSManagedObject, Decodable {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
      return NSFetchRequest<Exercise>(entityName: "Exercise")
  }

  @NSManaged public var category: String
  @NSManaged public var equipment: String?
  @NSManaged public var force: String?
  @NSManaged public var id: UUID
  @NSManaged public var level: String
  @NSManaged public var name: String
  @NSManaged public var primaryMuscles: [String]
  @NSManaged public var secondaryMuscles: [String]
  @NSManaged public var instructions: [String]
  @NSManaged public var imageUrls: [String]
  @NSManaged public var synchronized: Int
  
  public var synchronizationState: SynchronizationState {
    get {
      SynchronizationState(rawValue: synchronized) ?? .notSynchronized
    }
    set {
      synchronized = newValue.rawValue
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case category, equipment, force, id, level, name, primaryMuscles, secondaryMuscles, instructions, imageUrls, synchronized
  }
  
  public required convenience init(from decoder: Decoder) throws {
    guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
      fatalError("Managed object context not found!")
    }
    
    self.init(context: context)
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.category = try container.decode(String.self, forKey: .category)
    self.equipment = try container.decode(String.self, forKey: .equipment)
    self.force = try container.decode(String.self, forKey: .force)
    self.id = try container.decode(UUID.self, forKey: .id)
    self.level = try container.decode(String.self, forKey: .level)
    self.name = try container.decode(String.self, forKey: .name)
    self.primaryMuscles = try container.decode([String].self, forKey: .primaryMuscles)
    self.secondaryMuscles = try container.decode([String].self, forKey: .secondaryMuscles)
    self.instructions = try container.decode([String].self, forKey: .instructions)
    self.imageUrls = try container.decode([String].self, forKey: .imageUrls)
    self.synchronized = 1
  }
  
  static func findOrInsert(using identifier: UUID, in context: NSManagedObjectContext) -> Exercise {
    let request = Exercise.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", identifier as NSUUID)
    
    if let exercise = try? context.fetch(request).first {
      return exercise
    } else {
      let exercise = Exercise(context: context)
      return exercise
    }
  }
  
  func getImagesURLs() -> [URL] {
    guard imageUrls.count > 0 else { return [] }
    
    return imageUrls.compactMap { imageUrlString in
      URL(string: imageUrlString)
    }
  }

}

extension Exercise {
  enum ForceType: String, Codable {
    case pull, push, stay = "static"
  }
  
  enum Level: String, Codable {
    case intermediate, beginner, expert
  }
}
