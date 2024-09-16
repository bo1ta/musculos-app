//
//  Exercise+SyncableObject.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.09.2024.
//

import Utility
import Storage
import Models

extension Exercise: @retroactive SyncableObject {
  public typealias EntityType = ExerciseEntity

  public static let identifierKey: String = "exerciseId"

  public var identifierValue: String {
    self.id.uuidString
  }
}
