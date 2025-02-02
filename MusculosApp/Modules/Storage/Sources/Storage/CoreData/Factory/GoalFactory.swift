//
//  GoalFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 28.12.2024.
//

import Foundation
import Models

public final class GoalFactory: BaseFactory, @unchecked Sendable {
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
  public var isPersistent = true
  public var userID: UUID?

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
      userID: userID ?? user?.id ?? UserProfileFactory.createUser().id,
      updatedAt: updatedAt ?? Date())
    syncObject(goal, of: GoalEntity.self)
    return goal
  }

  public static func createGoal(user: UserProfile? = nil, isPersistent: Bool = true) -> Goal {
    let factory = GoalFactory()
    factory.user = user
    factory.isPersistent = isPersistent
    return factory.create()
  }
}
