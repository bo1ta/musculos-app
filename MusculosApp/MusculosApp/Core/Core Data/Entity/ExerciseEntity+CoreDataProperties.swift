//
//  ExerciseEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.09.2023.
//
//

import Foundation
import CoreData


extension ExerciseEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
        return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
    }

    @NSManaged public var id: Int
    @NSManaged public var uuid: String
    @NSManaged public var name: String
    @NSManaged public var exerciseBase: Int
    @NSManaged public var information: String
    @NSManaged public var created: String
    @NSManaged public var category: Int
    @NSManaged public var language: Int
    @NSManaged public var license: Int
    @NSManaged public var author: String?
    @NSManaged public var muscles: NSSet?
    @NSManaged public var equipments: NSSet?
}

// MARK: - Muscles
extension ExerciseEntity {
    @objc(addMusclesObject:)
    @NSManaged public func addToMuscles(_ value: MuscleEntity)

    @objc(removeMusclesObject:)
    @NSManaged public func removeFromMuscles(_ value: MuscleEntity)

    @objc(addMuscles:)
    @NSManaged public func addToMuscles(_ values: NSSet)

    @objc(removeMuscles:)
    @NSManaged public func removeFromMuscles(_ values: NSSet)
}

// MARK: - Equipments
extension ExerciseEntity {
    @objc(addEquipmentsObject:)
    @NSManaged public func addToEquipments(_ value: EquipmentEntity)

    @objc(removeEquipmentsObject:)
    @NSManaged public func removeFromEquipments(_ value: EquipmentEntity)

    @objc(addEquipments:)
    @NSManaged public func addToEquipments(_ values: NSSet)

    @objc(removeEquipments:)
    @NSManaged public func removeFromEquipments(_ values: NSSet)
}

extension ExerciseEntity : Identifiable { }

