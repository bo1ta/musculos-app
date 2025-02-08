//
//  HomeViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.09.2024.
//

import DataRepository
import Factory
import Foundation
import Models
import Observation
import Utility

@Observable
@MainActor
final class HomeViewModel: BaseViewModel {
  @ObservationIgnored
  @Injected(\.userStore) private var userStore: UserStoreProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.workoutRepository) private var workoutRepository: WorkoutRepositoryProtocol

  @ObservationIgnored
  @Injected(\.goalStore) private var goalStore: GoalStore

  var goals: [Goal] {
    goalStore.goals
  }

  private(set) var isLoading = false
  private(set) var quickExercises: [Exercise]?
  private(set) var workoutChallenge: WorkoutChallenge?

  func initialLoad() async {
    isLoading = true
    defer { isLoading = false }

    async let exercisesTask: Void = loadExercises()
    async let workoutTask: Void = loadWorkoutChallenge()
    _ = await (exercisesTask, workoutTask)
  }

  func loadWorkoutChallenge() async {
    do {
      workoutChallenge = try await workoutRepository.generateWorkoutChallenge()
    } catch {
      Logger.error(error, message: "Error loading workout challenges")
    }
  }

  func loadExercises() async {
    do {
      let exercises = try await exerciseRepository.getExercisesByWorkoutGoal(.improveEndurance)
      quickExercises = Array(exercises.prefix(2))
    } catch {
      Logger.error(error, message: "Error loading exercises for home view")
    }
  }
}
