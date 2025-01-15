//
//  ExploreViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 17.04.2024.
//

import DataRepository
import Factory
import Models
import Observation
import Utility

// MARK: - ExerciseResultCategory

enum ExerciseResultCategory: CaseIterable {
  case favorites
  case featured
  case recommendedByGoals
  case recommendedByPastSessions
}

// MARK: - ExploreViewModel

@Observable
@MainActor
final class ExploreViewModel {

  // MARK: Dependencies

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseSessionRepository) private var exerciseSessionRepository

  @ObservationIgnored
  @Injected(\.userStore) private var userStore: UserStoreProtocol

  // MARK: Public

  private(set) var isLoading = false
  private(set) var isLoaded = false
  private(set) var results: [ExerciseResultCategory: [Exercise]] = [:]
  private(set) var searchQueryTask: Task<Void, Never>?

  var recentSessions: [ExerciseSession] = []
  var progress: Float = 0.0
  var showFilterView = false

  var recommendedExercisesByPastSessions: [Exercise] {
    results[.recommendedByPastSessions] ?? []
  }

  var recommendedExercisesByGoals: [Exercise] {
    results[.recommendedByGoals] ?? []
  }

  var favoriteExercises: [Exercise] {
    results[.favorites] ?? []
  }

  var featuredExercises: [Exercise] {
    results[.featured] ?? []
  }

  var goals: [Goal] {
    userStore.currentUser?.goals ?? []
  }

  var goalDisplay: Goal? {
    goals.first
  }
}

// MARK: - Tasks

extension ExploreViewModel {
  func initialLoad() async {
    guard !isLoaded else {
      return
    }

    isLoading = true
    defer { isLoading = false }

    results[.featured] = await getExercises()
    results[.recommendedByGoals] = await loadRecommendationsByGoals()

    async let favoritesTask = loadFavoriteExercises()
    async let recommendationsTask = loadRecommendationsByPastSessions()
    async let recentSessionsTask = getSessionsCompletedToday()
    let (favorites, recommendations, recentSessions) = await (favoritesTask, recommendationsTask, recentSessionsTask)

    results[.favorites] = favorites
    results[.recommendedByPastSessions] = recommendations
    self.recentSessions = recentSessions

    isLoaded = true
  }

  nonisolated private func getExercises() async -> [Exercise] {
    do {
      return try await exerciseRepository.getExercises()
    } catch {
      Logger.error(error, message: "Could not load exercises")
      return []
    }
  }

  nonisolated private func loadRecommendationsByGoals() async -> [Exercise] {
    await exerciseRepository.getRecommendedExercisesByGoals()
  }

  nonisolated private func loadRecommendationsByPastSessions() async -> [Exercise] {
    do {
      return try await exerciseRepository.getRecommendedExercisesByMuscleGroups()
    } catch {
      Logger.error(error, message: "Could not load recommendations by past sessions")
      return []
    }
  }

  nonisolated private func loadFavoriteExercises() async -> [Exercise] {
    do {
      return try await exerciseRepository.getFavoriteExercises()
    } catch {
      Logger.error(error, message: "Data controller failed to get exercises")
      return []
    }
  }

  nonisolated private func getSessionsCompletedToday() async -> [ExerciseSession] {
    do {
      return try await exerciseSessionRepository.getCompletedToday()
    } catch {
      Logger.error(error, message: "Data controller failed to get exercises completed today")
      return []
    }
  }

  func searchByMuscleQuery(_ query: String) {
    searchQueryTask?.cancel()

    searchQueryTask = Task {
      do {
        results[.featured] = try await exerciseRepository.searchByQuery(query)
      } catch {
        Logger.error(error, message: "Could not search by muscle query", properties: ["query": query])
      }
    }
  }

  func cleanUp() {
    searchQueryTask?.cancel()
  }
}
