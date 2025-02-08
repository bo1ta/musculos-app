//
//  ProfileViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 29.12.2024.
//

import Components
import DataRepository
import Factory
import Models
import SwiftUI
import Utility

// MARK: - ProfileViewModel

@Observable
@MainActor
final class ProfileViewModel: BaseViewModel {

  // MARK: Depedencies

  @ObservationIgnored
  @LazyInjected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @LazyInjected(\DataRepositoryContainer.healthKitClient) private var healthKitClient: HealthKitClient

  @ObservationIgnored
  @LazyInjected(\DataRepositoryContainer.exerciseSessionRepository) private var sessionRepository

  @ObservationIgnored
  @LazyInjected(\.userStore) private var userStore: UserStoreProtocol

  // MARK: Public

  private(set) var favoriteExercises: [Exercise] = []
  private(set) var userTotalSteps = 0.0
  private(set) var userTotalSleep = 0
  private(set) var sessions: [ExerciseSession] = []
  private(set) var muscleChartData: [MuscleChartData] = []
  private(set) var sessionsChartData: [SessionChartData] = []

  var userLevel: Int {
    currentUser?.currentLevel ?? 0
  }

  var userLevelProgress: Double {
    currentUser?.currentLevelProgress ?? 0
  }

  var selectedWorkout: String?

  func initialLoad() async {
    await loadSessions()

    async let exerciseTask: Void = loadFavoriteExercises()
    async let healthKitTask: Void = loadHealthKitData()

    _ = await (exerciseTask, healthKitTask)
  }

  // MARK: Private

  private func loadFavoriteExercises() async {
    do {
      favoriteExercises = try await exerciseRepository.getFavoriteExercises()
    } catch {
      Logger.error(error, message: "Error loading favorite exercises")
    }
  }

  private func loadSessions() async {
    do {
      sessions = try await sessionRepository.getCompletedSinceLastWeek()
      updateChartDataForSessions(sessions)
    } catch {
      Logger.error(error, message: "Could not load past sessions")
    }
  }

  private func updateChartDataForSessions(_ sessions: [ExerciseSession]) {
    muscleChartData = sessions
      .flatMap { $0.exercise.muscleTypes }
      .reduce(into: [:]) { counts, muscle in
        counts[muscle.rawValue, default: 0] += 1
      }
      .map { MuscleChartData(muscle: $0.key, count: $0.value) }

    sessionsChartData = sessions
      .reduce(into: [:]) { result, session in
        let day = session.dateAdded.dayName()
        result[day, default: 0] += 1
      }
      .map { SessionChartData(dayName: $0.key, count: $0.value) }
  }

  private func loadHealthKitData() async {
    do {
      guard try await healthKitClient.requestPermissions() else {
        return
      }

      async let totalSleepTask = healthKitClient.getTotalSleepSinceLastWeek()
      async let totalStepsTask = healthKitClient.getTotalStepsSinceLastWeek()

      (userTotalSleep, userTotalSteps) = try await (totalSleepTask, totalStepsTask)

    } catch {
      Logger.error(error, message: "Error loading HealthKit data")
    }
  }
}
