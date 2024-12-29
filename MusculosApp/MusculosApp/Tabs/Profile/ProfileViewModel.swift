//
//  ProfileViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 29.12.2024.
//

import SwiftUI
import Factory
import Components
import Utility
import DataRepository
import Models

@Observable
@MainActor
final class ProfileViewModel {
  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.healthKitClient) private var healthKitClient: HealthKitClient

  private(set) var exercises: [Exercise] = []
  private(set) var userTotalSteps = 0.0
  private(set) var userTotalSleep = 0
  private(set) var toast: Toast?

  var selectedWorkout: String?

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
        toast = .warning("Not showing HealthKit data")
        return
      }

      async let totalSleepTask = healthKitClient.getTotalSleepSinceLastWeek()
      async let totalStepsTask = healthKitClient.getTotalStepsSinceLastWeek()

      (userTotalSleep, userTotalSteps) = try await (totalSleepTask, totalStepsTask)
    } catch {
      toast = .error("Unable to load HealthKit data")
      Logger.error(error, message: "Error loading HealthKit data")
    }
  }

  func getHighlights() -> [ProfileHighlight] {
    return [
      ProfileHighlight(highlightType: .steps, value: "5432", description: "updated 10 mins ago"),
      ProfileHighlight(highlightType: .sleep, value: "7 hr 31 min", description: "updated 10 mins ago"),
      ProfileHighlight(highlightType: .waterIntake, value: "4.2 ltr", description: "updated now"),
      ProfileHighlight(highlightType: .workoutTracking, value: "1 day since last workout", description: "updated a day ago"),
    ]
  }
}
