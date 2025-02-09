//
//  ProfileViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 29.12.2024.
//

import Combine
import Components
import DataRepository
import Factory
import Models
import Storage
import SwiftUI
import Utility

// MARK: - ProfileViewModel

@Observable
@MainActor
final class ProfileViewModel: BaseViewModel, TabViewModel {

  // MARK: Depedencies

  @ObservationIgnored
  @LazyInjected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @LazyInjected(\DataRepositoryContainer.healthKitClient) private var healthKitClient: HealthKitClient

  // MARK: Public

  private(set) var favoriteExercises: [Exercise] = []
  private(set) var fetchedResultsPublisher: FetchedResultsPublisher<ExerciseEntity>?
  private(set) var profileHighlightData: ProfileHighlightData?
  private(set) var cancellables: Set<AnyCancellable> = []

  var userLevel: Int {
    currentUser?.currentLevel ?? 0
  }

  var userLevelProgress: Double {
    currentUser?.currentLevelProgress ?? 0
  }

  var shouldLoad: Bool {
    favoriteExercises.isEmpty || profileHighlightData == nil
  }

  init() {
    fetchedResultsPublisher = StorageContainer.shared.exerciseDataStore().fetchedResultsPublisherForFavorites()
    fetchedResultsPublisher?.publisher
      .sink { [weak self] event in
        guard case .didUpdateContent(let newContent) = event else {
          return
        }
        self?.favoriteExercises = newContent
      }
      .store(in: &cancellables)
  }

  func initialLoad() async {
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

  private func loadHealthKitData() async {
    do {
      guard try await healthKitClient.requestPermissions() else {
        return
      }

      async let totalSleepTask = healthKitClient.getTotalSleepSinceLastWeek()
      async let totalStepsTask = healthKitClient.getTotalStepsSinceLastWeek()

      let (totalSleep, totalSteps) = try await (totalSleepTask, totalStepsTask)
      profileHighlightData = ProfileHighlightData(totalSteps: totalSteps, totalSleep: Double(totalSleep))
    } catch {
      Logger.error(error, message: "Error loading HealthKit data")
    }
  }
}
