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
  @Injected(\.exerciseService) private var service: ExerciseServiceProtocol

  @ObservationIgnored
  @Injected(\.userManager) private var userManager: UserManagerProtocol

  @ObservationIgnored
  @Injected(\.recommendationEngine) private var recommendationEngine: RecommendationEngine
  
  @ObservationIgnored
  @Injected(\.goalDataStore) private var goalDataStore: GoalDataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol
  
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
      handleChangeSection(currentSection)
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
    NotificationCenter.default.publisher(for: .CoreDataModelDidChange, object: nil)
      .sink { [weak self] notification in
        guard let event = notification.userInfo?[ModelUpdatedEvent.userInfoKey] as? ModelUpdatedEvent else { return }
        
        self?.handleUpdate(event)
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
    
    await loadRemoteExercises()
    
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
      recommendedByGoals = try await recommendationEngine.recommendByGoals()
    } catch {
      MusculosLogger.logError(error, message: "Could not load recommendations by goals", category: .coreData)
    }
  }

  private func loadRecommendationsByPastSessions() async {
    do {
      recommendedByPastSessions = try await recommendationEngine.recommendByMuscleGroups()
    } catch {
      MusculosLogger.logError(error, message: "Could not load recommendations by past sessions", category: .coreData)
    }
  }

  func loadRemoteExercises() async {
    do {
      let exercises = try await service.getExercises()
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
        let exercises = try await service.searchByMuscleQuery(query)
        contentState = .loaded(exercises)
      } catch {
        contentState = .error(MessageConstant.genericErrorMessage.rawValue)
        MusculosLogger.logError(error, message: "Could not search by muscle query", category: .networking, properties: ["query": query])
      }
    }
  }
  
  func loadLocalExercises() async {
    let exercises = await exerciseDataStore.getAll(fetchLimit: 20)
    contentState = .loaded(exercises)
  }
  
  func loadFavoriteExercises() async {
    let exercises = await exerciseDataStore.getAllFavorites()
    contentState = .loaded(exercises)
  }
  
  func refreshExercisesCompletedToday() async {
    guard let currentUser else { return }
    exercisesCompletedToday = await exerciseSessionDataStore.getCompletedToday(userId: currentUser.userId)
  }
  
  @MainActor
  func refreshGoals() async {
    goals = await goalDataStore.getAll()
  }
}

// MARK: - Section Handling

extension ExploreExerciseViewModel {
  func handleChangeSection(_ section: ExploreCategorySection) {
    updateTask?.cancel()
    
    updateTask = Task { @MainActor in
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
}

// MARK: - Model Event Handling

extension ExploreExerciseViewModel {
  func handleUpdate(_ event: ModelUpdatedEvent) {
    updateTask?.cancel()
    
    updateTask = Task {
      switch event {
      case .didAddGoal:
        await handleDidAddGoalEvent()
      case .didAddExerciseSession:
        await handleDidAddExerciseSession()
      case .didAddExercise:
        await handleDidAddExerciseEvent()
      case .didFavoriteExercise:
        await handleDidFavoriteExercise()
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
