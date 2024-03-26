//
//  Object.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import Foundation

protocol Object: AnyObject {
  associatedtype ObjectID
  
  var objectID: ObjectID { get }
  
  static var entityName: String { get }
}
