//
//  WorkoutDataStoreTests.swift
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
public class WorkoutDataStoreTests: MusculosTestBase {
  @Injected(\StorageContainer.workoutDataStore) private var dataStore

  @Test
  func workoutExeciseByID() async {
    let expectedWorkoutExercise = WorkoutExerciseFactory.createWorkoutExercise()
    let workoutExercise = await dataStore.workoutExerciseByID(expectedWorkoutExercise.id)
    #expect(workoutExercise == expectedWorkoutExercise)
    clearStorage()
  }

  @Test
  func workoutChallengeByID() async {
    let expectedWorkoutChallenge = WorkoutChallengeFactory.createWorkoutChallenge()
    let workoutChallenge = await dataStore.workoutChallengeByID(expectedWorkoutChallenge.id)
    #expect(workoutChallenge == expectedWorkoutChallenge)
    clearStorage()
  }

  @Test
  func getAllWorkoutChallenges() async {
    _ = WorkoutChallengeFactory.createWorkoutChallenge()
    _ = WorkoutChallengeFactory.createWorkoutChallenge()

    let workoutChallenges = await dataStore.getAllWorkoutChallenges()
    #expect(workoutChallenges.count == 2)
    clearStorage()
  }
}
