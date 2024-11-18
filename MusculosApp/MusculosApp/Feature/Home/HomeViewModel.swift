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

@MainActor
@Observable
final class HomeViewModel {
  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepository
  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepository

  private(set) var isLoading = false
  private(set) var challenges: [Challenge] = []
  private(set) var goals: [Goal] = []
  private(set) var errorMessage: String?

  func fetchData() async {
    isLoading = true
    defer { isLoading = false }

    do {
      goals = try await goalRepository.getGoals()
    } catch {
      MusculosLogger.logError(error, message: "Error loading goals for home view", category: .dataRepository)
    }
  }
}
