//
//  EquipmentEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.09.2023.
//
//

import Foundation
import CoreData


extension EquipmentEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EquipmentEntity> {
        return NSFetchRequest<EquipmentEntity>(entityName: "EquipmentEntity")
    }

    @NSManaged public var id: Int
    @NSManaged public var name: String

}

extension EquipmentEntity : Identifiable {

}
