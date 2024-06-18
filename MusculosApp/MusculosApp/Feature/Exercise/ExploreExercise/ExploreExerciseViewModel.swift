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

@Observable
final class ExploreExerciseViewModel {
  
  // MARK: - Dependencies
  
  @ObservationIgnored
  @Injected(\.exerciseModule) private var module: ExerciseModuleProtocol
  
  @ObservationIgnored
  @Injected(\.dataStore) private var dataStore: DataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.recommendationEngine) private var recommendationEngine: RecommendationEngine
  
  @ObservationIgnored
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Observed properties
  
  var exercisesCompletedToday: [ExerciseSession] = []
  var progress: Float = 0.0
  var goals: [Goal] = []
  var errorMessage = ""
  var searchQuery = ""
  var showFilterView = false
  var showExerciseDetails = false
  
  var selectedExercise: Exercise? = nil {
    didSet {
      if selectedExercise != nil {
        showExerciseDetails = true
      }
    }
  }
  
  var currentSection: ExploreCategorySection = .discover {
    didSet {
      handleChangeSection(currentSection)
    }
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
    NotificationCenter.default.publisher(for: .CoreModelDidChange, object: nil)
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
    do {
      async let recommendedByGoalsTask = recommendationEngine.recommendByGoals()
      async let recommendedByPastSessionsTask = recommendationEngine.recommendByMuscleGroups()
      
      let (recommendedByGoals, recommendedByPastSessions) = try await (recommendedByGoalsTask, recommendedByPastSessionsTask)
      
      self.recommendedByGoals = recommendedByGoals
      self.recommendedByPastSessions = recommendedByPastSessions
    } catch {
      MusculosLogger.logError(error, message: "Recommendation engine blew up!", category: .recommendationEngine)
    }
  }
  
  func loadRemoteExercises() async {
    do {
      let exercises = try await module.getExercises()
      await MainActor.run {
        contentState = .loaded(exercises)
      }
    } catch {
      await MainActor.run {
        contentState = .error(MessageConstant.genericErrorMessage.rawValue)
      }
      MusculosLogger.logError(error, message: "Could not load remote exercises", category: .networking)
    }
  }
  
  func searchByMuscleQuery(_ query: String) {
    exerciseTask?.cancel()
    
    exerciseTask = Task { @MainActor in
      contentState = .loading
      
      do {
        let exercises = try await module.searchByMuscleQuery(query)
        contentState = .loaded(exercises)
      } catch {
        contentState = .error(MessageConstant.genericErrorMessage.rawValue)
        MusculosLogger.logError(error, message: "Could not search by muscle query", category: .networking, properties: ["query": query])
      }
    }
  }
  
  @MainActor
  func loadLocalExercises() async {
    let exercises = await dataStore.loadExercises(fetchLimit: 20)
    contentState = .loaded(exercises)
  }
  
  @MainActor
  func loadFavoriteExercises() async {
    let exercises = await dataStore.exerciseDataStore.getAllFavorites()
    contentState = .loaded(exercises)
  }
  
  @MainActor
  func refreshExercisesCompletedToday() async {
    exercisesCompletedToday = await dataStore.exerciseSessionDataStore.getCompletedToday()
  }
  
  @MainActor
  func refreshGoals() async {
    goals = await dataStore.loadGoals()
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
    await dataStore.invalidateGoals()
    await refreshGoals()
  }
  
  private func handleDidAddExerciseSession() async {
    await dataStore.invalidateExerciseSessions()
    await refreshExercisesCompletedToday()
  }
  
  private func handleDidAddExerciseEvent() async {
    await dataStore.invalidateExercises()
    
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
