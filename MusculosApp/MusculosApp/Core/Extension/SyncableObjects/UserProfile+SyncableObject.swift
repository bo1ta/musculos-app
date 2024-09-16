//
//  UserProfile+SyncableObject.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.09.2024.
//

import Utility
import Storage
import Models

extension UserProfile: @retroactive SyncableObject {
  public typealias EntityType = UserProfileEntity

  public static let identifierKey: String = "userId"

  public var identifierValue: String {
    self.userId.uuidString
  }
}
