//
//  UserFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Foundation
import Models

public class UserProfileFactory: BaseFactory {
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
  public var xp: Int? = 0
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


public class GoalFactory: BaseFactory {
  public var id: UUID?
  public var name: String?
  public var category: String?
  public var frequency: Goal.Frequency?
  public var progressEntries: [ProgressEntry]?
  public var targetValue: Int?
  public var endDate: Date?
  public var dateAdded: Date?
  public var isCompleted: Bool?
  public var updatedAt: Date?
  public var user: UserProfile?

  public func create() -> Goal {
    let goal = Goal(
      id: id ?? UUID(),
      name: name ?? faker.lorem.words(amount: 3),
      category: category ?? ExerciseConstants.CategoryType.strength.rawValue,
      frequency: frequency ?? .daily,
      progressEntries: progressEntries,
      targetValue: targetValue ?? faker.number.randomInt(),
      endDate: endDate ?? faker.date.forward(4),
      isCompleted: isCompleted ?? false,
      dateAdded: dateAdded ?? Date(),
      user: user ?? UserProfileFactory.createUser(),
      updatedAt: updatedAt ?? Date()
    )
    syncObject(goal, of: GoalEntity.self)
    return goal
  }

  public static func createGoal() -> Goal {
    return GoalFactory().create()
  }
}
