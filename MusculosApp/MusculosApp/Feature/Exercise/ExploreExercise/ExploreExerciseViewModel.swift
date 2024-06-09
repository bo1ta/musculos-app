//
//  ExploreExerciseViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 17.04.2024.
//

import Foundation
import SwiftUI
import Factory
import Combine

final class ExploreExerciseViewModel: ObservableObject {
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol
  @Injected(\.goalDataStore) private var goalDataStore: GoalDataStoreProtocol
  @Injected(\.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  
  @Published var localResults: [Exercise] = []
  @Published var remoteResults: [Exercise] = []

  var resultsBinding: Binding<[Exercise]> {
    return Binding<[Exercise]>(get: { [weak self] in
      guard let self else { return [] }
      if self.currentSection == .discover {
        return self.remoteResults
      } else {
        return self.localResults
      }
    }, set: { _ in })
  }
  
  @Published var exercisesCompletedToday: [ExerciseSession] = []
  @Published var goals: [Goal] = []
  
  @Published var isLoading = false
  @Published var errorMessage = ""
  @Published var searchQuery = ""
  @Published var showFilterView = false
  @Published var showExerciseDetails = false
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
  private(set) var searchTask: Task<Void, Never>?
  private(set) var favoriteTask: Task<Void, Never>?
  private(set) var addExerciseTask: Task<Void, Never>?
  
  private let module: ExerciseModuleProtocol
  private var cancellables = Set<AnyCancellable>()
  
  init(module: ExerciseModuleProtocol = ExerciseModule()) {
    self.module = module
  }
  
  func handleUpdate(_ modelEvent: AppManager.ModelEvent) {
    switch modelEvent {
    case .didAddGoal:
      Task { await self.loadGoals() }
    case .didAddExerciseSession:
      Task { await self.loadExercisesCompletedToday() }
    case .didAddExercise:
      loadLocalExercises()
    case .didFavoriteExercise:
      loadFavoriteExercises()
    }
  }
  
  func loadRemoteExercises() {
    exerciseTask?.cancel()
    
    exerciseTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        let exercises = try await self.module.getExercises()
        self.remoteResults = exercises
      } catch {
        self.errorMessage = MessageConstant.genericErrorMessage.rawValue
        MusculosLogger.logError(error, message: "Could not load remote exercises", category: .networking)
      }
    }
  }
  
  func loadLocalExercises() {
    exerciseTask?.cancel()
    
    exerciseTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      let localExercises = await self.exerciseDataStore.getAll()
      self.localResults = localResults
    }
  }
  
  func loadFavoriteExercises() {
    exerciseTask?.cancel()
    
    exerciseTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      let favoriteExercises = await self.exerciseDataStore.getAllFavorites()
      self.localResults = favoriteExercises
    }
  }
  
  func searchByMuscleQuery(_ query: String) {
    searchTask?.cancel()
    
    searchTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        let exercises = try await self.module.searchByMuscleQuery(query)
        self.remoteResults = exercises
      } catch {
        self.errorMessage = MessageConstant.genericErrorMessage.rawValue
        MusculosLogger.logError(error, message: "Could not search by muscle query", category: .networking, properties: ["query": query])
      }
    }
  }
  
  func handleChangeSection(_ section: ExploreCategorySection) {
      switch section {
      case .discover:
        loadRemoteExercises()
      case .workout:
        loadLocalExercises()
      case .myFavorites:
        loadFavoriteExercises()
      }
  }
  
  func cleanUp() {
    exerciseTask?.cancel()
    exerciseTask = nil
    
    searchTask?.cancel()
    searchTask = nil
  }
    
  @MainActor
  func loadExercisesCompletedToday() async {
    self.exercisesCompletedToday = await exerciseSessionDataStore.getCompletedToday()
  }
  
  @MainActor
  func loadGoals() async {
    self.goals = await goalDataStore.getAll()
  }
  
  func initialLoad() async {
    await withTaskGroup(of: Void.self) { @MainActor [weak self] group in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      group.addTask { await self.loadExercisesCompletedToday() }
      group.addTask { await self.loadGoals() }
      
      await group.waitForAll()
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
