//
//  ExerciseEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.09.2023.
//
//

import Foundation
import CoreData

public class ExerciseEntity: NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "ExerciseEntity", in: context)!
        self.init(entity: entityDescription, insertInto: context)
    }
}
