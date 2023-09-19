//
//  EntityPlugin.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.09.2023.
//

import Foundation
import CoreData

protocol EntityPlugin {
    static func entityDescription(context: NSManagedObjectContext) -> NSEntityDescription?
}

extension EntityPlugin {
    static func entityDescription(context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: String(describing: self), in: context)
    }
}
