//
//  ExerciseStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.02.2024.
//

import Foundation
import SwiftUI

class ExerciseStore: ObservableObject {
  @Published var state: LoadingViewState<[Exercise]> = .empty
  
  private let module: ExerciseModuleProtocol
  private let fetchedResultsController: ResultsController<ExerciseEntity>
  
  init(module: ExerciseModuleProtocol = ExerciseModule(), shouldLoadFromCache: Bool = false) {
    self.module = module
    self.fetchedResultsController = ResultsController<ExerciseEntity>(storageManager: CoreDataStack.shared, sortedBy: [])
    self.setUpFetchedResultsController(shouldLoadFromCache: shouldLoadFromCache)
  }
  
  private(set) var exerciseTask: Task<Void, Never>?
  private(set) var searchTask: Task<Void, Never>?
  private(set) var favoriteTask: Task<Void, Never>?
  
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
    exerciseTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      do {
        let exercises = try await self.module.getExercises()
        self.state = .loaded(exercises)
      } catch {
        MusculosLogger.logError(error, message: "Could not load remote exercises", category: .networking)
        self.state = .error(MessageConstant.genericErrorMessage.rawValue)
      }
    }
  }

  func searchByMuscleQuery(_ query: String) {
    searchTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      do {
        let exercises = try await self.module.searchByMuscleQuery(query)
        self.state = .loaded(exercises)
      } catch {
        MusculosLogger.logError(error, message: "Could not search by muscle query", category: .networking, properties: ["query": query])
        self.state = .error(MessageConstant.genericErrorMessage.rawValue)
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
  }
}

// MARK: - Core Data

extension ExerciseStore {
  
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
  func checkIsFavorite(exercise: Exercise) -> Bool {
    return module.dataStore.isFavorite(exercise: exercise)
  }
  
  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) {
    favoriteTask = Task { @MainActor [weak self] in
      await self?.module.dataStore.markAsFavorite(exercise, isFavorite: isFavorite)
    }
  }
}

// MARK: - Fetched Results Controller Helpers

extension ExerciseStore {
  private func setUpFetchedResultsController(shouldLoadFromCache: Bool) {
    fetchedResultsController.onDidChangeContent = { [weak self] in
      self?.updateLocalResults()
    }
    fetchedResultsController.onDidResetContent = { [weak self] in
      self?.updateLocalResults()
    }
    
    /// perform initial fetch from data store. Default `true`
    guard shouldLoadFromCache else { return }

    do {
      try fetchedResultsController.performFetch()
      updateLocalResults()
    } catch {
      MusculosLogger.logError(error, message: "Could not perform fetch for results controller!", category: .coreData)
    }
  }
  
  private func updateLocalResults() {
    state = .loaded(fetchedResultsController.fetchedObjects)
  }
}
