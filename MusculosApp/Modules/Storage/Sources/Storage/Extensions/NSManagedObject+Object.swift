//
//  NSManagedObject+Object.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.03.2024.
//

import CoreData
import Foundation

extension NSManagedObject: Object {
  /// Returns the Entity Name, if available, as specified in the NSEntityDescription. Otherwise, will return
  /// the subclass name.
  ///
  public class var entityName: String {
    guard let name = NSStringFromClass(self).components(separatedBy: ".").last else {
      fatalError("Invalid entity name")
    }

    return name
  }
}
