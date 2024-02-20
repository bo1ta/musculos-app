//
//  ExerciseEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.02.2024.
//
//

import Foundation
import CoreData


extension ExerciseEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
        return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
    }

   

}

// MARK: Generated accessors for primaryMuscles
extension ExerciseEntity {
    @objc(addPrimaryMusclesObject:)
    @NSManaged public func addToPrimaryMuscles(_ value: StringHolder)

    @objc(removePrimaryMusclesObject:)
    @NSManaged public func removeFromPrimaryMuscles(_ value: StringHolder)

    @objc(addPrimaryMuscles:)
    @NSManaged public func addToPrimaryMuscles(_ values: NSSet)

    @objc(removePrimaryMuscles:)
    @NSManaged public func removeFromPrimaryMuscles(_ values: NSSet)

}

// MARK: Generated accessors for secondaryMuscles
extension ExerciseEntity {
    @objc(addSecondaryMusclesObject:)
    @NSManaged public func addToSecondaryMuscles(_ value: StringHolder)

    @objc(removeSecondaryMusclesObject:)
    @NSManaged public func removeFromSecondaryMuscles(_ value: StringHolder)

    @objc(addSecondaryMuscles:)
    @NSManaged public func addToSecondaryMuscles(_ values: NSSet)

    @objc(removeSecondaryMuscles:)
    @NSManaged public func removeFromSecondaryMuscles(_ values: NSSet)

}

// MARK: Generated accessors for instructions
extension ExerciseEntity {
    @objc(insertObject:inInstructionsAtIndex:)
    @NSManaged public func insertIntoInstructions(_ value: StringHolder, at idx: Int)

    @objc(removeObjectFromInstructionsAtIndex:)
    @NSManaged public func removeFromInstructions(at idx: Int)

    @objc(insertInstructions:atIndexes:)
    @NSManaged public func insertIntoInstructions(_ values: [StringHolder], at indexes: NSIndexSet)

    @objc(removeInstructionsAtIndexes:)
    @NSManaged public func removeFromInstructions(at indexes: NSIndexSet)

    @objc(replaceObjectInInstructionsAtIndex:withObject:)
    @NSManaged public func replaceInstructions(at idx: Int, with value: StringHolder)

    @objc(replaceInstructionsAtIndexes:withInstructions:)
    @NSManaged public func replaceInstructions(at indexes: NSIndexSet, with values: [StringHolder])

    @objc(addInstructionsObject:)
    @NSManaged public func addToInstructions(_ value: StringHolder)

    @objc(removeInstructionsObject:)
    @NSManaged public func removeFromInstructions(_ value: StringHolder)

    @objc(addInstructions:)
    @NSManaged public func addToInstructions(_ values: NSOrderedSet)

    @objc(removeInstructions:)
    @NSManaged public func removeFromInstructions(_ values: NSOrderedSet)

}

extension ExerciseEntity : Identifiable {
}
