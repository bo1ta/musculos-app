//
//  ExerciseSession+SyncableObject.swift
//  Storage
//
//  Created by Solomon Alexandru on 12.10.2024.
//

import Models

extension ExerciseSession: SyncableObject {
  public typealias EntityType = ExerciseSessionEntity

  public static let identifierKey: String = "sessionId"

  public var identifierValue: String {
    self.sessionId.uuidString
  }
}
