//
//  ExploreViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 17.04.2024.
//

import Combine
import CoreData
import DataRepository
import Factory
import Foundation
import Models
import Storage
import SwiftUI
import Utility

// MARK: - ExploreViewModel

@Observable
@MainActor
final class ExploreViewModel {
  // MARK: - Dependencies

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @Injected(
    \DataRepositoryContainer
      .exerciseSessionRepository) private var exerciseSessionRepository: ExerciseSessionRepositoryProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepositoryProtocol

  @ObservationIgnored
  @Injected(\StorageContainer.userManager) private var userManager: UserSessionManagerProtocol

  private var cancellables = Set<AnyCancellable>()
  private(set) var searchQueryTask: Task<Void, Never>?
  private(set) var notificationUpdateTask: Task<Void, Never>?

  // MARK: - Observed properties

  var exercisesCompletedToday: [ExerciseSession] = []
  var progress: Float = 0.0
  var goals: [Goal] = []
  var errorMessage = ""
  var showFilterView = false

  private(set) var isLoading = false
  private(set) var featuredExercises: [Exercise] = []
  private(set) var favoriteExercises: [Exercise] = []
  private(set) var recommendedExercisesByPastSessions: [Exercise] = []
  private(set) var recommendedExercisesByGoals: [Exercise] = []

  var displayGoal: Goal? {
    goals.first
  }

  var showRecommendationsByPastSessions: Bool {
    !recommendedExercisesByPastSessions.isEmpty
  }

  var showRecomendationsByGoals: Bool {
    !recommendedExercisesByGoals.isEmpty
  }

  var showFavoriteExercises: Bool {
    !favoriteExercises.isEmpty
  }

  func setFeaturedExercises(_ exercises: [Exercise]) {
    featuredExercises = exercises
  }

  func cleanUp() {
    cancellables.removeAll()
    searchQueryTask?.cancel()
    notificationUpdateTask?.cancel()
  }
}

// MARK: - Tasks

extension ExploreViewModel {
  func initialLoad() async {
    isLoading = true
    defer { isLoading = false }

    async let exercisesTask: Void = loadExercises()
    async let favoriteExercisesTask: Void = loadFavoriteExercises()
    async let recommendedExercisesByGoalsTask: Void = loadRecommendationsByGoals()
    async let recommendedExercisesByPastSessionsTask: Void = loadRecommendationsByPastSessions()
    async let completedTodayExercisesTask: Void = refreshExercisesCompletedToday()
    async let goalsTask: Void = loadGoals()

    _ = await (
      exercisesTask,
      favoriteExercisesTask,
      recommendedExercisesByGoalsTask,
      recommendedExercisesByPastSessionsTask,
      completedTodayExercisesTask,
      goalsTask)
  }

  private func loadExercises() async {
    do {
      featuredExercises = try await exerciseRepository.getExercises()
    } catch {
      Logger.error(error, message: "Could not load exercises")
    }
  }

  private func loadRecommendationsByGoals() async {
    recommendedExercisesByGoals = await exerciseRepository.getRecommendedExercisesByGoals()
  }

  private func loadRecommendationsByPastSessions() async {
    do {
      recommendedExercisesByPastSessions = try await exerciseRepository.getRecommendedExercisesByMuscleGroups()
    } catch {
      Logger.error(error, message: "Could not load recommendations by past sessions")
    }
  }

  private func loadFavoriteExercises() async {
    do {
      favoriteExercises = try await exerciseRepository.getFavoriteExercises()
    } catch {
      Logger.error(error, message: "Data controller failed to get exercises")
    }
  }

  func refreshExercisesCompletedToday() async {
    do {
      exercisesCompletedToday = try await exerciseSessionRepository.getCompletedToday()
    } catch {
      Logger.error(error, message: "Data controller failed to get exercises completed today")
    }
  }

  private func loadGoals() async {
    do {
      goals = try await goalRepository.getGoals()
    } catch {
      Logger.error(error, message: "Could not get goals")
    }
  }

  func searchByMuscleQuery(_ query: String) {
    searchQueryTask?.cancel()

    searchQueryTask = Task {
      do {
        featuredExercises = try await exerciseRepository.searchByQuery(query)
      } catch {
        Logger.error(error, message: "Could not search by muscle query", properties: ["query": query])
      }
    }
  }
}

// MARK: - Model Event Handling

extension ExploreViewModel {
  func handleUpdate(_ event: CoreModelNotificationHandler.Event) {
    notificationUpdateTask?.cancel()

    notificationUpdateTask = Task {
      Logger.info(message: "Did notify someone: \(event)")
      switch event {
      case .didUpdateGoal:
        await loadGoals()
      case .didUpdateExercise:
        await loadFavoriteExercises()
      case .didUpdateExerciseSession:
        await loadRecommendationsByPastSessions()
        await refreshExercisesCompletedToday()
      }
    }
  }
}
