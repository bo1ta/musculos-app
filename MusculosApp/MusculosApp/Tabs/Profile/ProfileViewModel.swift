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

@Observable
@MainActor
final class ProfileViewModel {

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.userStore) private var userStore: UserStore

  @ObservationIgnored
  @Injected(\.toastManager) private var toastManager: ToastManager

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.healthKitClient) private var healthKitClient: HealthKitClient

  private(set) var exercises: [Exercise] = []
  private(set) var userTotalSteps = 0.0
  private(set) var userTotalSleep = 0
  var selectedWorkout: String?

  var currentUser: UserProfile? {
    userStore.currentUser
  }

  func initialLoad() async {
    async let exerciseTask: Void = loadFavoriteExercises()
    async let healthKitTask: Void = loadHealthKitData()

    _ = await (exerciseTask, healthKitTask)
  }

  private func loadFavoriteExercises() async {
    do {
      exercises = try await exerciseRepository.getFavoriteExercises()
    } catch {
      Logger.error(error, message: "Error loading favorite exercises")
    }
  }

  private func loadHealthKitData() async {
    do {
      guard try await healthKitClient.requestPermissions() else {
        toastManager.showWarning("Not showing HealthKit data")
        return
      }

      async let totalSleepTask = healthKitClient.getTotalSleepSinceLastWeek()
      async let totalStepsTask = healthKitClient.getTotalStepsSinceLastWeek()

      (userTotalSleep, userTotalSteps) = try await (totalSleepTask, totalStepsTask)
    } catch {
      toastManager.showError("Unable to load HealthKit data")
      Logger.error(error, message: "Error loading HealthKit data")
    }
  }

  func getHighlights() -> [ProfileHighlight] {
    [
      ProfileHighlight(highlightType: .steps, value: "5432", description: "updated 10 mins ago"),
      ProfileHighlight(highlightType: .sleep, value: "7 hr 31 min", description: "updated 10 mins ago"),
      ProfileHighlight(highlightType: .waterIntake, value: "4.2 ltr", description: "updated now"),
      ProfileHighlight(highlightType: .workoutTracking, value: "1 day since last workout", description: "updated a day ago"),
    ]
  }
}
