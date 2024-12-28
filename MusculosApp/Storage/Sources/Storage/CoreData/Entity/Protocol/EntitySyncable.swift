//
//  EntitySyncable.swift
//
//
//  Created by Solomon Alexandru on 15.09.2024.
//

import CoreData
import Foundation
import Utility

public protocol EntitySyncable: Object {
  associatedtype ModelType: IdentifiableEntity

  func populateEntityFrom(_ model: ModelType, using storage: StorageType)
  func updateEntityFrom(_ model: ModelType, using storage: StorageType)
}
