//
//  EntityMappable.swift
//
//
//  Created by Solomon Alexandru on 15.09.2024.
//

import Foundation
import CoreData
import Utility

public protocol EntitySyncable {
  associatedtype ModelType: Codable

  func populateEntityFrom(_ model: ModelType, using storage: StorageType) throws
  func updateEntityFrom(_ model: ModelType, using storage: StorageType) throws
}
