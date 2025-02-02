//
//  ExerciseSessionDataStoreTests.swift
//  Storage
//
//  Created by Solomon Alexandru on 02.02.2025.
//

import Factory
import Foundation
import Models
import Testing
@testable import Storage
@testable import Utility

@Suite(.serialized)
public class ExerciseSessionDataStoreTests: MusculosTestBase {
  @Injected(\StorageContainer.exerciseSessionDataStore) private var dataStore

  @Test
  func exerciseSessionsForUser() async {
    let user = UserProfileFactory.createUser()
    _ = ExerciseSessionFactory.make { factory in
      factory.user = user
    }

    let sessions = await dataStore.exerciseSessionsForUser(user.id)
    #expect(sessions.count == 1)

    clearStorage()
  }

  @Test
  func exerciseSessionsCompletedToday() async {
    let user = UserProfileFactory.createUser()
    _ = ExerciseSessionFactory.make { factory in
      factory.user = user
    }
    _ = ExerciseSessionFactory.make { factory in
      factory.user = user
      factory.dateAdded = Date.distantPast
    }

    let sessions = await dataStore.exerciseSessionCompletedToday(for: user.id)
    #expect(sessions.count == 1)

    clearStorage()
  }

  @Test
  func exerciseSessionsCompletedSinceLastWeek() async {
    let user = UserProfileFactory.createUser()
    _ = ExerciseSessionFactory.make { factory in
      factory.user = user
    }
    _ = ExerciseSessionFactory.make { factory in
      factory.user = user
      factory.dateAdded = DateHelper.nowPlusDays(-4)
    }
    _ = ExerciseSessionFactory.make { factory in
      factory.user = user
      factory.dateAdded = Date.distantPast
    }

    let sessions = await dataStore.exerciseSessionsCompletedSinceLastWeek(for: user.id)
    #expect(sessions.count == 2)

    clearStorage()
  }

  @Test
  func exerciseSessionByID() async {
    let expectedSession = ExerciseSessionFactory.createExerciseSession()
    let exerciseSession = await dataStore.exerciseSessionByID(expectedSession.id)
    #expect(exerciseSession == expectedSession)

    clearStorage()
  }
}
