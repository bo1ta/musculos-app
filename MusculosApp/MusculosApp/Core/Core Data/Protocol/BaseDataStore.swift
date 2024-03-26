//
//  BaseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.03.2024.
//

import Foundation
import CoreData

protocol BaseDataStore {
  var writerDerivedStorage: StorageType { get }
  var viewStorage: StorageType { get }
}

extension BaseDataStore {
  var writerDerivedStorage: StorageType {
    CoreDataStack.shared.writerDerivedStorage
  }
  
  var viewStorage: StorageType {
    CoreDataStack.shared.viewStorage
  }
}
