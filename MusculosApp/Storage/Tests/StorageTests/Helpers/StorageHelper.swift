//
//  StorageHelper.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Factory
import Foundation
import Models

class StorageHelper {
  nonisolated(unsafe) static let shared = StorageHelper()

  private var isStoragePopulated = false

  func populateStorageIfNeeded(_: [Exercise] = [ExerciseFactory.createExercise()]) async throws {
    guard !isStoragePopulated else {
      return
    }

    isStoragePopulated = true
  }
}
