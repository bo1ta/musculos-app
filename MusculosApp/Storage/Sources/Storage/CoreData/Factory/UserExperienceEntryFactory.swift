//
//  UserExperienceEntryFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Foundation
import Models

public class UserExperienceEntryFactory: BaseFactory, @unchecked Sendable {
  public var id: UUID?
  public var userExperience: UserExperience?
  public var xpGained: Int?
  public var isPersistent: Bool = true

  public func create() -> UserExperienceEntry {
    let userExperience = UserExperienceEntry(
      id: id ?? UUID(),
      userExperience: userExperience ?? UserExperienceFactory.createUserExperience(),
      xpGained: 100)
    syncObject(userExperience, of: UserExperienceEntryEntity.self)
    return userExperience
  }

  public static func createUserExperienceEntry() -> UserExperienceEntry {
    return UserExperienceEntryFactory().create()
  }
}
