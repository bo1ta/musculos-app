//
//  StringHolder+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.09.2023.
//
//

import Foundation
import CoreData


extension StringHolder {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StringHolder> {
        return NSFetchRequest<StringHolder>(entityName: "StringHolder")
    }

    @NSManaged public var string: String
}

extension StringHolder : Identifiable {
}
