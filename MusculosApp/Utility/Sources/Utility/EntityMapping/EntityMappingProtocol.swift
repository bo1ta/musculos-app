//
//  EntityMappingProtocol.swift
//  
//
//  Created by Solomon Alexandru on 15.09.2024.
//

import Foundation
import CoreData

public protocol EntityMappingProtocol {
  func setEntityValue(_ entity: NSManagedObject) throws
}

extension EntityMapping: EntityMappingProtocol {
  public func setEntityValue(_ entity: NSManagedObject) throws {
    try entity.setValue(self.wrappedValue, forKey: self.key)
  }
}
