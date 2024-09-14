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

@Observable
@MainActor
final class ExploreExerciseViewModel {

  // MARK: - Dependencies

  @ObservationIgnored
  @Injected(\.dataController) private var dataController: DataController

  @ObservationIgnored
  @Injected(\.exerciseService) private var exerciseService: ExerciseServiceProtocol

  @ObservationIgnored
  @Injected(\.userManager) private var userManager: UserManagerProtocol

  @ObservationIgnored
  private var cancellables = Set<AnyCancellable>()

  private var currentUser: UserSession? {
    userManager.currentSession()
  }

  // MARK: - Observed properties

  var exercisesCompletedToday: [ExerciseSession] = []
  var progress: Float = 0.0
  var goals: [Goal] = []
  var errorMessage = ""
  var searchQuery = ""
  var showFilterView = false

  var currentSection: ExploreCategorySection = .discover {
    didSet {
      didChangeSection(to: currentSection)
    }
  }

  var displayGoal: Goal? {
    return goals
      .first
  }

  var contentState: LoadingViewState<[Exercise]> = .empty
  var recommendedByGoals: [Exercise]?
  var recommendedByPastSessions: [Exercise]?

  // MARK: - Tasks

  @ObservationIgnored
  private(set) var exerciseTask: Task<Void, Never>?

  @ObservationIgnored
  private(set) var updateTask: Task<Void, Never>?

  // MARK: - Init

  init() {
    setupNotificationPublisher()
  }

  // MARK: - Initial setup

  private func setupNotificationPublisher() {
    dataController
      .modelEventPublisher
      .debounce(for: .milliseconds(700), scheduler: RunLoop.main)
      .sink { [weak self] updateObjectEvent in
        self?.handleUpdate(updateObjectEvent)
      }
      .store(in: &cancellables)
  }

  // MARK: - Clean up

  func cleanUp() {
    exerciseTask?.cancel()
    exerciseTask = nil

    updateTask?.cancel()
    updateTask = nil
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
      recommendedByGoals = try await dataController.getRecommendedExercisesByGoals()
    } catch {
      MusculosLogger.logError(error, message: "Could not load recommendations by goals", category: .coreData)
    }
  }

  private func loadRecommendationsByPastSessions() async {
    do {
      recommendedByPastSessions = try await dataController.getRecommendedExercisesByMuscleGroups()
    } catch {
      MusculosLogger.logError(error, message: "Could not load recommendations by past sessions", category: .coreData)
    }
  }

  func loadRemoteExercises() async {
    do {
      let exercises = try await exerciseService.getExercises()
      contentState = .loaded(exercises)
    } catch {
      contentState = .error(MessageConstant.genericErrorMessage.rawValue)
      MusculosLogger.logError(error, message: "Could not load remote exercises", category: .networking)
    }
  }

  func searchByMuscleQuery(_ query: String) {
    exerciseTask?.cancel()

    exerciseTask = Task {
      contentState = .loading

      do {
        let exercises = try await exerciseService.searchByMuscleQuery(query)
        contentState = .loaded(exercises)
      } catch {
        contentState = .error(MessageConstant.genericErrorMessage.rawValue)
        MusculosLogger.logError(error, message: "Could not search by muscle query", category: .networking, properties: ["query": query])
      }
    }
  }

  func loadLocalExercises() async {
    do {
      let exercises = try await dataController.getExercises()
      contentState = .loaded(exercises)
    } catch {
      contentState = .error(MessageConstant.genericErrorMessage.rawValue)
      MusculosLogger.logError(error, message: "Data controller failed to get exercises", category: .coreData)
    }
  }

  func loadFavoriteExercises() async {
    do {
      let exercises = try await dataController.getFavoriteExercises()
      contentState = .loaded(exercises)
    } catch {
      contentState = .error(MessageConstant.genericErrorMessage.rawValue)
      MusculosLogger.logError(error, message: "Data controller failed to get exercises", category: .coreData)
    }
  }

  func refreshExercisesCompletedToday() async {
    do {
      exercisesCompletedToday = try await dataController.getExercisesCompletedToday()
    } catch {
      MusculosLogger.logError(error, message: "Data controller failed to get exercises completed today", category: .coreData)
    }
  }

  @MainActor
  func refreshGoals() async {
    do {
      goals = try await dataController.getGoals()
    } catch {
      MusculosLogger.logError(error, message: "Data controller failed to get goals", category: .coreData)
    }
  }
}

// MARK: - Section Handling

extension ExploreExerciseViewModel {
  private func didChangeSection(to section: ExploreCategorySection) {
    updateTask?.cancel()

    updateTask = Task { [weak self] in
      await self?.loadExercisesForSection(section)
    }
  }

  private func loadExercisesForSection(_ section: ExploreCategorySection) async {
    switch section {
    case .discover:
      await loadRemoteExercises()
    case .workout:
      await loadLocalExercises()
    case .myFavorites:
      await loadFavoriteExercises()
    }
  }
}

// MARK: - Model Event Handling

extension ExploreExerciseViewModel {
  func handleUpdate(_ event: CoreModelNotificationHandler.Event) {
    updateTask?.cancel()

    updateTask = Task {
      switch event {
      case .didUpdateGoal:
        await refreshGoals()
      case .didUpdateExercise:
        switch currentSection {
        case .myFavorites:
          await loadFavoriteExercises()
        case .workout:
          await loadLocalExercises()
        case .discover:
          break
        }
      case .didUpdateExerciseSession:
        await updateRecommendations()
      }
    }
  }

  private func handleDidAddGoalEvent() async {
    await refreshGoals()
  }

  private func handleDidAddExerciseSession() async {
    await refreshExercisesCompletedToday()
    await refreshGoals()
  }

  private func handleDidAddExerciseEvent() async {
    if currentSection == .workout {
      await loadLocalExercises()
    }
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
      "My Favorites"
    }
  }
}
