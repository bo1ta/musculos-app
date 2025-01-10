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

  // MARK: Depedencies

  @ObservationIgnored
  @LazyInjected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @LazyInjected(\DataRepositoryContainer.healthKitClient) private var healthKitClient: HealthKitClient

  @ObservationIgnored
  @LazyInjected(\.toastManager) private var toastManager: ToastManagerProtocol

  @ObservationIgnored
  @LazyInjected(\.currentUser) var currentUser: UserProfile?

  // MARK: Public

  private(set) var exercises: [Exercise] = []
  private(set) var userTotalSteps = 0.0
  private(set) var userTotalSleep = 0

  var selectedWorkout: String?

  func initialLoad() async {
    async let exerciseTask: Void = loadFavoriteExercises()
    async let healthKitTask: Void = loadHealthKitData()

    _ = await (exerciseTask, healthKitTask)
  }

  // MARK: Private

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
        toastManager.showInfo("Not showing HealthKit data")
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
}
