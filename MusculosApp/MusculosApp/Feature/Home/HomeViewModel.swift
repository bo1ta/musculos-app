//
//  HomeViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.09.2024.
//

import Observation
import Storage
import Models
import Utility
import Factory
import DataRepository
import Storage

@Observable
final class HomeViewModel {

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepository
  @ObservationIgnored
  @Injected(\StorageContainer.goalDataStore) private var goalDataStore: GoalDataStoreProtocol

  private(set) var currentUser: UserProfile?
  private(set) var isLoading = false
  private(set) var recommendedExercises: [Exercise] = []
  private(set) var challenges: [Challenge] = []
  private(set) var goals: [Goal] = []
  private(set) var errorMessage: String?

  @MainActor
  func fetchData() async {
    isLoading = true
    defer { isLoading = false }

    await withTaskGroup(of: Void.self) { [weak self] group in
      group.addTask {
        self?.goals = await self?.goalDataStore.getAll() ?? []
      }
      group.addTask {
        do {
          self?.recommendedExercises = try await self?.exerciseRepository.getExercises() ?? []
        } catch {
          MusculosLogger.logError(error, message: "Error fetching exercises", category: .dataRepository)
        }
      }
    }
  }
}
