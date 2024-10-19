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
  @Injected(\StorageContainer.goalDataStore) private var goalDataStore: GoalDataStoreProtocol

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
  var searchQuery = ""
  var showFilterView = false
  var contentState: LoadingViewState<[Exercise]> = .empty
  var recommendedByGoals: [Exercise]?
  var recommendedByPastSessions: [Exercise]?

  var currentSection: ExploreCategorySection = .discover {
    didSet {
      didChangeSection(to: currentSection)
    }
  }

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

  func cleanUp() {
    taskManager.cancelAllTasks()
    cancellables.removeAll()
  }
}

// MARK: - Tasks

extension ExploreExerciseViewModel {
  func initialLoad() async {
    guard contentState == .empty else { return }
    contentState = .loading

    async let completedTodayExercisesTask: Void = refreshExercisesCompletedToday()
    async let goalsTask: Void = refreshGoals()

    await loadExercisesForSection(currentSection)

    let (_, _) = await (completedTodayExercisesTask, goalsTask)

    await updateRecommendations()
  }

  func updateRecommendations() async {
    async let recommendedByGoalsTask: Void = loadRecommendationsByGoals()
    async let recommendedByPastSessionsTask: Void = loadRecommendationsByPastSessions()

    _ = await (recommendedByGoalsTask, recommendedByPastSessionsTask)
  }

  private func loadRecommendationsByGoals() async {
    do {
      recommendedByGoals = try await exerciseRepository.getRecommendedExercisesByGoals()
    } catch {
      MusculosLogger.logError(error, message: "Could not load recommendations by goals", category: .coreData)
    }
  }

  private func loadRecommendationsByPastSessions() async {
    do {
      recommendedByPastSessions = try await exerciseRepository.getRecommendedExercisesByMuscleGroups()
    } catch {
      MusculosLogger.logError(error, message: "Could not load recommendations by past sessions", category: .coreData)
    }
  }

  func searchByMuscleQuery(_ query: String) {
    taskManager.cancelTask(forFunction: #function)

    let task = Task {
      contentState = .loading

      do {
        let exercises = try await exerciseRepository.searchByMuscleQuery(query)
        contentState = .loaded(exercises)
      } catch {
        contentState = .error(MessageConstant.genericErrorMessage.rawValue)
        MusculosLogger.logError(error, message: "Could not search by muscle query", category: .networking, properties: ["query": query])
      }
    }
    taskManager.addTask(task)
  }


  func loadFavoriteExercises() async {
    do {
      let exercises = try await exerciseRepository.getFavoriteExercises()
      contentState = .loaded(exercises)
    } catch {
      contentState = .error(MessageConstant.genericErrorMessage.rawValue)
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

  @MainActor
  func refreshGoals() async {
    goals = await goalDataStore.getAll()
  }
}

// MARK: - Section Handling

extension ExploreExerciseViewModel {
  private func didChangeSection(to section: ExploreCategorySection) {
    taskManager.cancelTask(forFunction: #function)

    taskManager.addTask(Task { [weak self] in
      await self?.loadExercisesForSection(section)
    })
  }

  private func loadExercises() async {
    do {
      let exercises = try await exerciseRepository.getExercises()
      contentState = .loaded(exercises)
    } catch {
      MusculosLogger.logError(error, message: "Could not load exercises", category: .dataRepository)
    }
  }

  private func loadExercisesForSection(_ section: ExploreCategorySection) async {
    switch section {
    case .discover:
      await loadExercises()
    case .workout:
      await loadRecommendationsByPastSessions()
      self.contentState = .loaded(recommendedByPastSessions ?? [])
    case .myFavorites:
      await loadFavoriteExercises()
    }
  }
}

// MARK: - Model Event Handling

extension ExploreExerciseViewModel {
  func handleUpdate(_ event: CoreModelNotificationHandler.Event) {
    let task = Task {
      switch event {
      case .didUpdateGoal:
        await refreshGoals()
      case .didUpdateExercise:
        switch currentSection {
        case .myFavorites:
          await loadFavoriteExercises()
        case .workout, .discover:
          break
        }
      case .didUpdateExerciseSession:
        await updateRecommendations()
      }
    }

    taskManager.addTask(task)
  }

  private func handleDidAddGoalEvent() async {
    await refreshGoals()
  }

  private func handleDidAddExerciseSession() async {
    await refreshExercisesCompletedToday()
    await refreshGoals()
  }

  private func handleDidFavoriteExercise() async {
    guard currentSection == .myFavorites else { return }
    await loadFavoriteExercises()
  }
}

// MARK: - Helpers

enum ExploreCategorySection: String, CaseIterable {
  case discover, workout, myFavorites

  var title: String {
    switch self {
    case .discover:
      "Discover"
    case .workout:
      "Workout"
    case .myFavorites:
      "Favorites"
    }
  }
}
