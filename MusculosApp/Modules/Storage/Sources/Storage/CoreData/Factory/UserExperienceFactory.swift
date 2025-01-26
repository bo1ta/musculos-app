//
//  UserExperienceFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Foundation
import Models

public class UserExperienceFactory: BaseFactory, @unchecked Sendable {
  public var id: UUID?
  public var totalExperience: Int?
  public var experienceEntries: [UserExperienceEntry]?
  public var isPersistent = true

  public func create() -> UserExperience {
    let userExperience = UserExperience(
      id: id ?? UUID(),
      totalExperience: totalExperience ?? 100,
      experienceEntries: experienceEntries)
    syncObject(userExperience, of: UserExperienceEntity.self)
    return userExperience
  }

  public static func createUserExperience() -> UserExperience {
    UserExperienceFactory().create()
  }
}
