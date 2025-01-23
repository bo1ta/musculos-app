//
//  ExploreViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 17.04.2024.
//

import Combine
import DataRepository
import Factory
import Models
import Observation
import Storage
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
final class ExploreViewModel: BaseViewModel {

  // MARK: Dependencies

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseSessionRepository) private var exerciseSessionRepository

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
}

// MARK: - Tasks

extension ExploreViewModel {
  func initialLoad() async {
    guard !isLoaded else {
      return
    }

    isLoading = true
    defer { isLoading = false }

    async let recommendations: Void = loadRecommandations()
    async let exercises: Void = loadExercises()
    async let sessions: Void = loadRecentSessions()
    _ = await (recommendations, exercises, sessions)

    isLoaded = true
  }

  private func loadExercises() async {
    await loadFavoriteExercises()

    for await result in await exerciseRepository.getExercisesStream() {
      switch result {
      case .success(let success):
        results[.featured] = success
      case .failure(let failure):
        Logger.error(failure, message: "Something went wrong!")
      }
    }
  }

  private func loadRecommandations() async {
    do {
      results[.recommendedByGoals] = await exerciseRepository.getRecommendedExercisesByGoals()
      results[.recommendedByPastSessions] = try await exerciseRepository.getRecommendedExercisesByMuscleGroups()
    } catch {
      Logger.error(error, message: "Could not load recommendations by past sessions")
    }
  }

  private func loadFavoriteExercises() async {
    do {
      results[.favorites] = try await exerciseRepository.getFavoriteExercises()
    } catch {
      Logger.error(error, message: "Data controller failed to get exercises")
    }
  }

  private func loadRecentSessions() async {
    do {
      recentSessions = try await exerciseSessionRepository.getCompletedToday()
    } catch {
      Logger.error(error, message: "Data controller failed to get exercises completed today")
    }
  }

  func searchByMuscleQuery(_ query: String) {
    searchQueryTask = Task {
      do {
        results[.featured] = try await exerciseRepository.searchByQuery(query)
      } catch {
        Logger.error(error, message: "Could not search by muscle query", properties: ["query": query])
      }
    }
  }

  func setFilteredExercises(_ exercises: [Exercise]) {
    results[.featured] = exercises
  }

  func cleanUp() {
    searchQueryTask?.cancel()
  }
}
