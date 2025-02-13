//
//  UserProfileFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Foundation
import Models

public final class UserProfileFactory: BaseFactory, @unchecked Sendable {
  public var id: UUID?
  public var avatar: String?
  public var fullName: String?
  public var username: String?
  public var email: String?
  public var gender: String?
  public var weight: Double?
  public var height: Double?
  public var level: String?
  public var availableEquipment: [String]?
  public var primaryGoalID: UUID?
  public var isOnboarded: Bool?
  public var totalExperience: Int?
  public var goals: [Goal]?
  public var ratings: [ExerciseRating]?
  public var userExperience: UserExperience?
  public var isPersistent = true

  public func create() -> UserProfile {
    let model = UserProfile(
      id: id ?? UUID(),
      email: email ?? faker.internet.email(),
      fullName: fullName ?? faker.name.name(),
      username: username ?? faker.internet.username(),
      avatar: avatar ?? faker.internet.url(),
      gender: gender ?? faker.gender.type(),
      weight: weight ?? faker.number.randomDouble(),
      height: height ?? faker.number.randomDouble(),
      level: level ?? ExerciseConstants.LevelType.beginner.rawValue,
      availableEquipment: availableEquipment ?? [ExerciseConstants.EquipmentType.bodyOnly.rawValue],
      primaryGoalID: primaryGoalID ?? UUID(),
      isOnboarded: isOnboarded ?? true,
      totalExperience: totalExperience,
      goals: goals,
      ratings: ratings,
      userExperience: userExperience ?? UserExperienceFactory.createUserExperience())
    syncObject(model, of: UserProfileEntity.self)
    return model
  }

  public static func createUser(isPersistent: Bool = true) -> UserProfile {
    let factory = UserProfileFactory()
    factory.isPersistent = isPersistent
    return factory.create()
  }
}
