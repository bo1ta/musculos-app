//
//  ExploreExerciseViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 17.04.2024.
//

import Foundation
import SwiftUI
import Factory

final class ExploreExerciseViewModel: ObservableObject {
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol
  @Injected(\.goalDataStore) private var goalDataStore: GoalDataStoreProtocol
  @Injected(\.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  
  private var localResults: [Exercise] = []
  private var remoteResults: [Exercise] = []
  
  @Published var exercisesCompletedToday: [ExerciseSession] = []
  @Published var goals: [Goal] = []
  @Published var errorMessage = ""
  @Published var searchQuery = ""
  
  @Published var showFilterView = false
  @Published var showExerciseDetails = false
  
  @Published var contentState: LoadingViewState<[Exercise]> = .empty
  
  @Published var selectedExercise: Exercise? = nil {
    didSet {
      if selectedExercise != nil {
        showExerciseDetails = true
      }
    }
  }
  
  @Published var currentSection: ExploreCategorySection = .discover {
    didSet {
      handleChangeSection(currentSection)
    }
  }
  
  private(set) var exerciseTask: Task<Void, Never>?
  private(set) var initialLoadTask: Task<Void, Never>?
  private(set) var updateTask: Task<Void, Never>?
  
  private let module: ExerciseModuleProtocol
  
  init(module: ExerciseModuleProtocol = ExerciseModule()) {
    self.module = module
  }
  
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
  
  func refreshLocalExercises() {
    exerciseTask?.cancel()
    
    exerciseTask = Task {
      let exercises = await exerciseDataStore.getAll()
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
  
  @MainActor
  func refreshExercisesCompletedToday() async {
    exercisesCompletedToday = await exerciseSessionDataStore.getCompletedToday()
  }
  
  @MainActor
  func refreshGoals() async {
    goals = await goalDataStore.getAll()
  }
}

// MARK: - Handlers

extension ExploreExerciseViewModel {
  func handleChangeSection(_ section: ExploreCategorySection) {
    updateTask?.cancel()
    
    updateTask = Task {
      switch section {
      case .discover:
        refreshRemoteExercises()
        
        await exerciseTask?.value
        await updateContentState(with: remoteResults)
        
      case .workout:
        refreshLocalExercises()
        
        await exerciseTask?.value
        await updateContentState(with: localResults)
      case .myFavorites:
        refreshFavoriteExercises()
        
        await exerciseTask?.value
        await updateContentState(with: localResults)
      }
    }
  }
  
  func handleUpdate(_ modelEvent: AppManager.ModelEvent) {
    updateTask?.cancel()
    
    updateTask = Task {
      switch modelEvent {
      case .didAddGoal:
        await refreshGoals()
      case .didAddExerciseSession:
        await refreshExercisesCompletedToday()
      case .didAddExercise:
        refreshLocalExercises()
        await exerciseTask?.value
        
        if currentSection == .workout {
          await updateContentState(with: localResults)
        }
      case .didFavoriteExercise:
        if currentSection == .myFavorites {
          refreshFavoriteExercises()
          
          await exerciseTask?.value
          await updateContentState(with: localResults)
        }
      }
    }
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
