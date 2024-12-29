//
//  UserProfileFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Foundation
import Models

public class UserProfileFactory: BaseFactory, @unchecked Sendable {
  public var userId: UUID?
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
  public var xp: Int? = 0 // swiftlint:disable:this identifier_name
  public var goals: [Goal]?
  public var ratings: [ExerciseRating]?

  public func create() -> UserProfile {
    let model = UserProfile(
      userId: userId ?? UUID(),
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
      xp: xp,
      goals: goals,
      ratings: ratings
    )
    syncObject(model, of: UserProfileEntity.self)
    return model
  }

  public static func createUser() -> UserProfile {
    return UserProfileFactory().create()
  }
}
