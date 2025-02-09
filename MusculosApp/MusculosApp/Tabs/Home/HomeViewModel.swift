//
//  HomeViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.09.2024.
//

import Combine
import DataRepository
import Factory
import Foundation
import Models
import Observation
import Utility

@Observable
@MainActor
final class HomeViewModel: BaseViewModel, TabViewModel {

  // MARK: Dependencies

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.workoutRepository) private var workoutRepository: WorkoutRepositoryProtocol

  // MARK: Properties

  private var goalObserver: AnyCancellable?
  private(set) var quickExercises = LoadingViewState<[Exercise]>.empty
  private(set) var workoutChallenge = LoadingViewState<WorkoutChallenge>.empty
  private(set) var goals: [Goal] = []

  var shouldLoad: Bool {
    quickExercises.isLoadable || workoutChallenge.isLoadable
  }

  // MARK: Methods

  func initialLoad() async {
    setupGoalObserver()

    guard shouldLoad else {
      return
    }

    async let exercisesTask: Void = loadExercises()
    async let workoutTask: Void = loadWorkoutChallenge()

    _ = await (exercisesTask, workoutTask)
  }

  private func setupGoalObserver() {
    goals = currentUser?.goals ?? []

    goalObserver = userStore.eventPublisher
      .sink { event in
        guard
          case .didUpdateUser(let userProfile) = event,
          let goals = userProfile.goals,
          goals.count != self.goals.count
        else {
          return
        }
        self.goals = goals
      }
  }

  private func loadWorkoutChallenge() async {
    guard workoutChallenge.isLoadable else {
      return
    }

    workoutChallenge = .loading

    do {
      let result = try await workoutRepository.generateWorkoutChallenge()
      workoutChallenge = .loaded(result)
    } catch {
      workoutChallenge = .error(error)
      Logger.error(error, message: "Error loading workout challenges")
    }
  }

  private func loadExercises() async {
    guard quickExercises.isLoadable else {
      return
    }

    quickExercises = .loading

    do {
      let exercises = try await exerciseRepository.getExercisesByWorkoutGoal(.improveEndurance)
      let firstTwoExercises = Array(exercises.prefix(2))
      quickExercises.assignResult(firstTwoExercises)
    } catch {
      quickExercises = .error(error)
      Logger.error(error, message: "Error loading exercises for home view")
    }
  }

  func onDisappear() {
    goalObserver?.cancel()
    goalObserver = nil
  }
}
