//
//  EquipmentEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.09.2023.
//
//

import Foundation
import CoreData

public class EquipmentEntity: NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "EquipmentEntity", in: context)!
        self.init(entity: entityDescription, insertInto: context)
    }
}

extension EquipmentEntity: EntityPlugin { }
