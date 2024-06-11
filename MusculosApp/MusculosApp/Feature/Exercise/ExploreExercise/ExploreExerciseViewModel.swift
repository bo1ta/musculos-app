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
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.goalDataStore) private var goalDataStore: GoalDataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  
  @ObservationIgnored
  private var localResults: [Exercise] = []
  
  @ObservationIgnored
  private var remoteResults: [Exercise] = []
  
  // MARK: - Observed properties
  
  var exercisesCompletedToday: [ExerciseSession] = []
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
  
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Tasks
  
  @ObservationIgnored
  private(set) var exerciseTask: Task<Void, Never>?
  
  @ObservationIgnored
  private(set) var initialLoadTask: Task<Void, Never>?
  
  @ObservationIgnored
  private(set) var updateTask: Task<Void, Never>?
  
  // MARK: - Init
  
  init() {
    setupNotificationPublisher()
  }
  
  private func setupNotificationPublisher() {
    NotificationCenter.default.publisher(for: .CoreModelDidChange, object: nil)
      .sink { [weak self] notification in
        guard let event = notification.userInfo?[UpdatableModel.userInfoKey] as? UpdatableModel else { return }
        
        self?.handleUpdate(event)
      }
      .store(in: &cancellables)
  }
  
  // MARK: - Initial setup
  
  func initialLoad() {
    guard contentState == .empty else { return }
    
    initialLoadTask = Task { @MainActor in
      await withTaskGroup(of: Void.self) { group in
        contentState = .loading
        
        group.addTask {
          await self.refreshExercisesCompletedToday()
        }
        
        group.addTask {
          await self.refreshGoals()
        }
        
        group.addTask {
          self.refreshRemoteExercises()
          await self.exerciseTask?.value
          await self.updateContentState(with: self.remoteResults)
        }
        
        await group.waitForAll()
      }
    }
  }
  
  @MainActor
  func updateContentState(with exercises: [Exercise]) {
    contentState = .loaded(exercises)
  }
  
  // MARK: - Clean up
  
  func cleanUp() {
    exerciseTask?.cancel()
    exerciseTask = nil
    
    initialLoadTask?.cancel()
    initialLoadTask = nil
    
    updateTask?.cancel()
    updateTask = nil
  }
}

// MARK: - Tasks

extension ExploreExerciseViewModel {
  func refreshRemoteExercises() {
    exerciseTask?.cancel()
    
    exerciseTask = Task {
      do {
        let exercises = try await module.getExercises()
        remoteResults = exercises
      } catch {
        await MainActor.run {
          errorMessage = MessageConstant.genericErrorMessage.rawValue
        }
        MusculosLogger.logError(error, message: "Could not load remote exercises", category: .networking)
      }
    }
  }
  
  func searchByMuscleQuery(_ query: String) {
    exerciseTask?.cancel()
    
    exerciseTask = Task {
      contentState = .loading
      
      do {
        let exercises = try await module.searchByMuscleQuery(query)
        remoteResults = exercises
        
        contentState = .loaded(exercises)
      } catch {
        self.errorMessage = MessageConstant.genericErrorMessage.rawValue
        MusculosLogger.logError(error, message: "Could not search by muscle query", category: .networking, properties: ["query": query])
      }
    }
  }
  
  func refreshLocalExercises() {
    exerciseTask?.cancel()
    
    exerciseTask = Task {
      let exercises = await exerciseDataStore.getAll(fetchLimit: 20)
      localResults = exercises
    }
  }
  
  func refreshFavoriteExercises() {
    exerciseTask?.cancel()
    
    exerciseTask = Task {
      let favoriteExercises = await exerciseDataStore.getAllFavorites()
      localResults = favoriteExercises
    }
  }
  
  
  @MainActor
  func refreshExercisesCompletedToday() async {
    exercisesCompletedToday = await exerciseSessionDataStore.getCompletedToday()
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
    
    updateTask = Task {
      switch section {
      case .discover:
        await handleDiscoverSection()
      case .workout:
        await handleWorkoutSection()
      case .myFavorites:
        await handleFavoriteSection()
      }
    }
  }
  
  private func handleDiscoverSection() async {
    refreshRemoteExercises()
    
    await waitForExerciseTask()
    await updateContentState(with: remoteResults)
  }
  
  private func handleWorkoutSection() async {
    refreshLocalExercises()
    
    await waitForExerciseTask()
    await updateContentState(with: localResults)
  }
  
  private func handleFavoriteSection() async {
    refreshFavoriteExercises()
    
    await exerciseTask?.value
    await updateContentState(with: localResults)
  }
  
  private func waitForExerciseTask() async {
    await exerciseTask?.value
  }
}

// MARK: - Model Event Handling

extension ExploreExerciseViewModel {
  func handleUpdate(_ modelEvent: UpdatableModel) {
    updateTask?.cancel()
    
    updateTask = Task {
      switch modelEvent {
      case .didAddGoal:
        await refreshGoals()
      case .didAddExerciseSession:
        await refreshExercisesCompletedToday()
      case .didAddExercise:
        await handleAddExerciseEvent()
      case .didFavoriteExercise:
        await handleDidFavoriteExercise()
      }
    }
  }
  
  private func handleAddExerciseEvent() async {
    refreshLocalExercises()
    await waitForExerciseTask()
    
    if currentSection == .workout {
      await updateContentState(with: localResults)
    }
  }
  
  private func handleDidFavoriteExercise() async {
    guard currentSection == .myFavorites else { return }
    
    refreshFavoriteExercises()
    
    await waitForExerciseTask()
    await updateContentState(with: localResults)
  }
}

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
