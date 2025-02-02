//
//  GoalDataStoreTests.swift
//  Storage
//
//  Created by Solomon Alexandru on 02.02.2025.
//

import Factory
import Foundation
import Models
import Testing
@testable import Storage

@Suite(.serialized)
public class GoalDataStoreTests: MusculosTestBase {
  @Injected(\StorageContainer.goalDataStore) private var dataStore

  @Test
  func getGoalsForUser() async {
    let user = UserProfileFactory.createUser()
    let expectedGoal = GoalFactory.make { factory in
      factory.userID = user.id
    }

    let goals = await dataStore.getGoalsForUserID(user.id)
    #expect(goals.count == 1)
    #expect(goals.first?.name == expectedGoal.name)

    clearStorage()
  }

  @Test
  func updateGoalProgress() async throws {
    let user = UserProfileFactory.createUser()
    let exercise = ExerciseFactory.make { factory in
      factory.category = ExerciseConstants.CategoryType.cardio.rawValue
    }
    let goal = GoalFactory.make { factory in
      factory.userID = user.id
      factory.category = Goal.Category.loseWeight.rawValue
    }
    let exerciseSession = ExerciseSessionFactory.make { factory in
      factory.user = user
      factory.exercise = exercise
    }

    try await dataStore.updateGoalProgress(userID: user.id, exerciseSession: exerciseSession)

    let progressEntries = await dataStore.progressEntriesForGoalID(goal.id)
    #expect(progressEntries.count == 1)

    clearStorage()
  }

  @Test
  func goalByID() async {
    let expectedGoal = GoalFactory.createGoal()

    let goal = await dataStore.goalByID(expectedGoal.id)
    #expect(goal?.name == expectedGoal.name)

    clearStorage()
  }

  @Test
  func goalsPublisherForUserID() async {
    let user = UserProfileFactory.createUser()
    _ = GoalFactory.make { factory in
      factory.userID = user.id
      factory.user = user
    }

    let goalPublisher = dataStore.goalsPublisherForUserID(user.id)
    #expect(goalPublisher.fetchedObjects.count == 1)

    _ = GoalFactory.make { factory in
      factory.userID = user.id
    }

    #expect(goalPublisher.fetchedObjects.count == 2)

    clearStorage()
  }
}
