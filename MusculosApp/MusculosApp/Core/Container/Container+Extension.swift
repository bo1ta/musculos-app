//
//  Container+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.05.2024.
//

import Foundation
import Factory

extension Container {
  var storageManager: Factory<StorageManagerType> {
    self { StorageManager() }
      .singleton
  }
  
  var exerciseDataStore: Factory<ExerciseDataStoreProtocol> {
    self { ExerciseDataStore() }
  }
  
  var userDataStore: Factory<UserDataStoreProtocol> {
    self { UserDataStore() }
  }
  
  var exerciseSessionDataStore: Factory<ExerciseSessionDataStoreProtocol> {
    self { ExerciseSessionDataStore() }
  }
}
