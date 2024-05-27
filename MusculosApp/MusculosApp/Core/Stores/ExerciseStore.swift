//
//  ExerciseStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.02.2024.
//

import Foundation
import SwiftUI
import Factory

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
    guard query.count > 4 else { return }
    
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
    
    addExerciseTask?.cancel()
    addExerciseTask = nil
  }
}

// MARK: - Core Data

extension ExerciseStore {
  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) {
    favoriteTask = Task { [weak self] in
      await self?.module.dataStore.setIsFavorite(exercise, isFavorite: isFavorite)
    }
  }
  
  func addExercise(_ exercise: Exercise) {
    addExerciseTask = Task { [weak self] in
      await self?.module.dataStore.add(exercise)
    }
  }
  
  @MainActor
  func filterByMuscles(muscles: [String]) {
    let muscleTypes = muscles.compactMap { MuscleType(rawValue: $0) }
    let exercises = module.dataStore.getByMuscles(muscleTypes)
    self.state = .loaded(exercises)
  }
  
  func filterByMuscles(
    muscles: [String],
    level: String = "",
    categories: [String] = [],
    equipments: [String] = []
  ) -> [Exercise] {
    let muscleTypes = muscles.compactMap { MuscleType(rawValue: $0) }
    var filteredExercises = module.dataStore.getByMuscles(muscleTypes)
    
    if categories.count > 0 {
      filteredExercises = filteredExercises.filter { categories.contains($0.category) }
    }
    
    if equipments.count > 0 {
      filteredExercises = filteredExercises.filter { exercise in
        if let equipment = exercise.equipment {
          return equipments.contains(equipment)
        } else {
          return true
        }
      }
    }
    
    if level.count > 0 {
      filteredExercises = filteredExercises.filter { $0.level == level }
    }
    
    return filteredExercises
  }
  
  @MainActor
  func checkIsFavorite(exercise: Exercise) -> Bool {
    return module.dataStore.isFavorite(exercise)
  }
}

// MARK: - Fetched Results Controller Helpers

extension ExerciseStore {
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
  
  func updateLocalResults() {
    storedExercises = fetchedResultsController.fetchedObjects
  }
  
  func loadLocalExercises() {
    fetchedResultsController.predicate = nil
    updateLocalResults()
  }
  
  func loadFavoriteExercises() {
    fetchedResultsController.predicate = ExerciseEntity.CommonPredicate.isFavorite.nsPredicate
    updateLocalResults()
  }
  
  func loadForName(_ name: String) {
    fetchedResultsController.predicate = ExerciseEntity.CommonPredicate.byName(name).nsPredicate
    updateLocalResults()
  }
}
