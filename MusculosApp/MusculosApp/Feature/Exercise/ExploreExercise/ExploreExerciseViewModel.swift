//
//  ExploreExerciseViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 17.04.2024.
//

import Foundation
import SwiftUI
import Combine
import Factory
import Utility
import Models
import Storage
import DataRepository
import CoreData

@Observable
@MainActor
final class ExploreExerciseViewModel {

  // MARK: - Dependencies

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseSessionRepository) private var exerciseSessionRepository: ExerciseSessionRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepository

  @ObservationIgnored
  @Injected(\StorageContainer.userManager) private var userManager: UserSessionManagerProtocol

  @ObservationIgnored
  @Injected(\.taskManager) private var taskManager: TaskManagerProtocol

  private var cancellables = Set<AnyCancellable>()

  private var currentUser: UserSession? {
    userManager.currentUserSession
  }

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
    return goals.first
  }

  // MARK: - Init

  private let coreModelNotificationHandler: CoreModelNotificationHandler

  init() {
    self.coreModelNotificationHandler = CoreModelNotificationHandler(
      storageType: StorageContainer.shared.storageManager().writerDerivedStorage
    )
    self.coreModelNotificationHandler.eventPublisher
      .debounce(for: .milliseconds(700), scheduler: RunLoop.main)
      .sink { [weak self] updateObjectEvent in
        self?.handleUpdate(updateObjectEvent)
      }
      .store(in: &cancellables)
  }

  func setFeaturedExercises(_ exercises: [Exercise]) {
    featuredExercises = exercises
  }

  func cleanUp() {
    taskManager.cancelAllTasks()
    cancellables.removeAll()
  }
}

// MARK: - Tasks

extension ExploreExerciseViewModel {
  func initialLoad() async {
    isLoading = true
    defer { isLoading = false }

    async let exercisesTask: Void = loadExercises()
    async let favoriteExercisesTask: Void = loadFavoriteExercises()
    async let recommendedExercisesByGoalsTask: Void = loadRecommendationsByGoals()
    async let recommendedExercisesByPastSessionsTask: Void = loadRecommendationsByPastSessions()
    async let completedTodayExercisesTask: Void = refreshExercisesCompletedToday()
    async let goalsTask: Void = loadGoals()

    let (_, _, _, _, _, _) = await (exercisesTask, favoriteExercisesTask, recommendedExercisesByGoalsTask, recommendedExercisesByPastSessionsTask, completedTodayExercisesTask, goalsTask)
  }

  private func loadExercises() async {
    do {
      featuredExercises = try await exerciseRepository.getExercises()
    } catch {
      MusculosLogger.logError(error, message: "Could not load exercises", category: .dataRepository)
    }
  }

  private func loadRecommendationsByGoals() async {
    do {
      recommendedExercisesByGoals = try await exerciseRepository.getRecommendedExercisesByGoals()
    } catch {
      MusculosLogger.logError(error, message: "Could not load recommendations by goals", category: .coreData)
    }
  }

  private func loadRecommendationsByPastSessions() async {
    do {
      recommendedExercisesByPastSessions = try await exerciseRepository.getRecommendedExercisesByMuscleGroups()
    } catch {
      MusculosLogger.logError(error, message: "Could not load recommendations by past sessions", category: .coreData)
    }
  }

  func searchByMuscleQuery(_ query: String) {
    taskManager.cancelTask(forFunction: #function)

    let task = Task {
      do {
        featuredExercises = try await exerciseRepository.searchByMuscleQuery(query)
      } catch {
        MusculosLogger.logError(error, message: "Could not search by muscle query", category: .networking, properties: ["query": query])
      }
    }
    taskManager.addTask(task)
  }

  private func loadFavoriteExercises() async {
    do {
      favoriteExercises = try await exerciseRepository.getFavoriteExercises()
    } catch {
      MusculosLogger.logError(error, message: "Data controller failed to get exercises", category: .coreData)
    }
  }

  func refreshExercisesCompletedToday() async {
    do {
      exercisesCompletedToday = try await exerciseSessionRepository.getCompletedToday()
    } catch {
      MusculosLogger.logError(error, message: "Data controller failed to get exercises completed today", category: .coreData)
    }
  }

  private func loadGoals() async {
    do {
      goals = try await goalRepository.getGoals()
    } catch {
      MusculosLogger.logError(error, message: "Could not get goals", category: .dataRepository)
    }
  }
}

// MARK: - Model Event Handling

extension ExploreExerciseViewModel {
  func handleUpdate(_ event: CoreModelNotificationHandler.Event) {
    let task = Task {
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

    taskManager.addTask(task)
  }
}
