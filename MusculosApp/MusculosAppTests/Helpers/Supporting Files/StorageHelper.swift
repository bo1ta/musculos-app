//
//  StorageHelper.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Foundation
@testable import MusculosApp

class StorageHelper {
  static let shared = StorageHelper()
  
  private var isStoragePopulated = false
  
  func populateStorageIfNeeded(_ exercises: [Exercise] = [ExerciseFactory.createExercise()]) async throws {
    guard !isStoragePopulated else { return }
    
    let exerciseDataStore = ExerciseDataStore()
    _ = try await exerciseDataStore.importFrom(exercises)
    
    isStoragePopulated = true
  }
}

