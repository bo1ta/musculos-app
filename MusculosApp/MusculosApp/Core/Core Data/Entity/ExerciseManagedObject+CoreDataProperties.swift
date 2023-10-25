//
//  ExerciseManagedObject+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.10.2023.
//
//

import Foundation
import CoreData


extension ExerciseManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseManagedObject> {
        return NSFetchRequest<ExerciseManagedObject>(entityName: "ExerciseManagedObject")
    }

    @NSManaged public var bodyPart: String
    @NSManaged public var equipment: String
    @NSManaged public var gifUrl: String
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var target: String
    @NSManaged @objc(isFavorite) public var isFavorite: Bool
    @NSManaged public var instructions: NSSet?
    @NSManaged public var secondaryMuscles: NSSet?

}

// MARK: Generated accessors for instructions
extension ExerciseManagedObject {

    @objc(addInstructionsObject:)
    @NSManaged public func addToInstructions(_ value: StringHolder)

    @objc(removeInstructionsObject:)
    @NSManaged public func removeFromInstructions(_ value: StringHolder)

    @objc(addInstructions:)
    @NSManaged public func addToInstructions(_ values: NSSet)

    @objc(removeInstructions:)
    @NSManaged public func removeFromInstructions(_ values: NSSet)

}

// MARK: Generated accessors for secondaryMuscles
extension ExerciseManagedObject {

    @objc(addSecondaryMusclesObject:)
    @NSManaged public func addToSecondaryMuscles(_ value: StringHolder)

    @objc(removeSecondaryMusclesObject:)
    @NSManaged public func removeFromSecondaryMuscles(_ value: StringHolder)

    @objc(addSecondaryMuscles:)
    @NSManaged public func addToSecondaryMuscles(_ values: NSSet)

    @objc(removeSecondaryMuscles:)
    @NSManaged public func removeFromSecondaryMuscles(_ values: NSSet)

}

extension ExerciseManagedObject : Identifiable {

}
