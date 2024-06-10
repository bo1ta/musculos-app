//
//  ExerciseStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.02.2024.
//

import Foundation
import SwiftUI
import Factory

@MainActor final class ExerciseFetchedResultsController: ObservableObject {
  @Published var results: [Exercise] = []
  
  private let fetchedResultsController: ResultsController<ExerciseEntity>

  init() {
    self.fetchedResultsController = ResultsController<ExerciseEntity>(storageManager: Container.shared.storageManager(), sortedBy: [])
    self.setUpFetchedResultsController()
  }
  
  private func setUpFetchedResultsController() {
    fetchedResultsController.onDidChangeContent = { [weak self] in
      self?.updateLocalResults()
    }
    
    fetchedResultsController.onDidResetContent = { [weak self] in
      self?.updateLocalResults()
    }
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      MusculosLogger.logError(error, message: "Could not perform fetch for results controller!", category: .coreData)
    }
  }
  
  func updateLocalResults(predicate: NSPredicate? = nil) {
    fetchedResultsController.predicate = predicate
    results = fetchedResultsController.fetchedObjects
  }
  
  func loadFavoriteExercises() {
    let predicate = ExerciseEntity.CommonPredicate.isFavorite.nsPredicate
    updateLocalResults(predicate: predicate)
  }
  
  func loadForName(_ name: String) {
    let predicate = ExerciseEntity.CommonPredicate.byName(name).nsPredicate
    updateLocalResults(predicate: predicate)
  }
}

class ExerciseStore: ObservableObject {
  @Published var state: LoadingViewState<[Exercise]> = .empty
  @Published var storedExercises: [Exercise] = []
  
  private let module: ExerciseModuleProtocol
  private let fetchedResultsController: ResultsController<ExerciseEntity>
  
  init(module: ExerciseModuleProtocol = ExerciseModule()) {
    self.module = module
    self.fetchedResultsController = ResultsController<ExerciseEntity>(storageManager: Container.shared.storageManager(), sortedBy: [])
    self.setUpFetchedResultsController()
  }
  
  private(set) var exerciseTask: Task<Void, Never>?
  private(set) var searchTask: Task<Void, Never>?
  private(set) var favoriteTask: Task<Void, Never>?
  private(set) var addExerciseTask: Task<Void, Never>?
  
  var discoverExercises: [[Exercise]] {
    if case let LoadingViewState.loaded(exercises) = state {
      return exercises.chunked(into: 5)
    }
    return [[]]
  }
}

// MARK: - Networking

extension ExerciseStore {
  func loadRemoteExercises() {
    exerciseTask?.cancel()
    
    exerciseTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      do {
        let exercises = try await self.module.getExercises()
        self.state = .loaded(exercises)
      } catch {
        self.state = .error(MessageConstant.genericErrorMessage.rawValue)
        MusculosLogger.logError(error, message: "Could not load remote exercises", category: .networking)
      }
    }
  }
  
  func searchByMuscleQuery(_ query: String) {
    searchTask?.cancel()
    
    searchTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      do {
        let exercises = try await self.module.searchByMuscleQuery(query)
        self.state = .loaded(exercises)
      } catch {
        self.state = .error(MessageConstant.genericErrorMessage.rawValue)
        MusculosLogger.logError(error, message: "Could not search by muscle query", category: .networking, properties: ["query": query])
      }
    }
  }
  
  func cleanUp() {
    searchTask?.cancel()
    searchTask = nil
    
    favoriteTask?.cancel()
    favoriteTask = nil
    
    exerciseTask?.cancel()
    exerciseTask = nil
    
    addExerciseTask?.cancel()
    addExerciseTask = nil
  }
}

// MARK: - Core Data

extension ExerciseStore {
  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) {
    favoriteTask?.cancel()
    
    favoriteTask = Task.detached { [weak self] in
      guard let self else { return }
      
      do {
        try await self.module.dataStore.setIsFavorite(exercise, isFavorite: isFavorite)
      } catch {
        MusculosLogger.logError(error, message: "Could not update isFavorite", category: .coreData, properties: ["exercise_name": exercise.name])
      }
    }
  }
  
  func addExercise(_ exercise: Exercise) {
    addExerciseTask?.cancel()
    
    addExerciseTask = Task { [weak self] in
      guard let self else { return }
      
      do {
        try await self.module.dataStore.add(exercise)
      } catch {
        MusculosLogger.logError(error, message: "Could not add exercise", category: .coreData, properties: ["exercise_name": exercise.name])
      }
    }
  }
  
  @MainActor
  func filterByMuscles(muscles: [String]) async {
    let muscleTypes = muscles.compactMap { MuscleType(rawValue: $0) }
    let exercises = await module.dataStore.getByMuscles(muscleTypes)
    self.state = .loaded(exercises)
  }
  
  @MainActor
  func checkIsFavorite(exercise: Exercise) async -> Bool {
    return await module.dataStore.isFavorite(exercise)
  }
}

// MARK: - Fetched Results Controller Helpers

extension ExerciseStore {
  private func setUpFetchedResultsController() {
    fetchedResultsController.onDidChangeContent = { [weak self] in
      guard let updateLocalResults = self?.updateLocalResults else { return }
      Task {
        await updateLocalResults()
      }
    }
    
    fetchedResultsController.onDidResetContent = { [weak self] in
      guard let updateLocalResults = self?.updateLocalResults else { return }
      Task {
        await updateLocalResults()
      }
    }
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      MusculosLogger.logError(error, message: "Could not perform fetch for results controller!", category: .coreData)
    }
  }
  
  @MainActor
  func updateLocalResults() {
    storedExercises = fetchedResultsController.fetchedObjects
  }
  
  @MainActor
  func loadLocalExercises() {
    fetchedResultsController.predicate = nil
    updateLocalResults()
  }
  
  @MainActor
  func loadFavoriteExercises() {
    fetchedResultsController.predicate = ExerciseEntity.CommonPredicate.isFavorite.nsPredicate
    updateLocalResults()
  }
  
  @MainActor
  func loadForName(_ name: String) {
    fetchedResultsController.predicate = ExerciseEntity.CommonPredicate.byName(name).nsPredicate
    updateLocalResults()
  }
}
