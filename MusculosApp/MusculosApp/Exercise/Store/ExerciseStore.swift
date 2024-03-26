//
//  ExerciseStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.02.2024.
//

import Foundation
import SwiftUI

class ExerciseStore: ObservableObject {
  @Published var state: LoadingViewState<[Exercise]> = .empty("")
  
  private let module: ExerciseModuleProtocol
  
  private let exerciseFetchedResultsController: ResultsController<ExerciseEntity>?
  
  init(module: ExerciseModuleProtocol = ExerciseModule()) {
    self.module = module
    self.exerciseFetchedResultsController = ResultsController<ExerciseEntity>(storageManager: CoreDataStack.shared, sortedBy: [])
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
  
  func loadExercises() {
    exerciseTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      do {
        let exercises = try await self.module.getExercises()
        self.state = .loaded(exercises)
      } catch {
        self.state = .error(error.localizedDescription)
      }
    }
  }
  
  @MainActor
  func loadLocalExercises() {
    state = .loading
    
    do {
      let exercises = try module.dataStore.fetchExercises()
      state = .loaded(exercises)
    } catch {
      state = .error(error.localizedDescription)
    }
  }
    
  @MainActor
  func loadFavoriteExercises() {
    state = .loading

    do {
      let exercises = try module.dataStore.fetchFavoriteExercises()
      state = .loaded(exercises)
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  @MainActor
  func searchByMuscleQuery(_ query: String) {
    searchTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      do {
        let exercises = try await self.module.searchByMuscleQuery(query)
        self.state = .loaded(exercises)
      } catch {
        self.state = .error(error.localizedDescription)
      }
    }
  }
  
  @MainActor
  func checkIsFavorite(exercise: Exercise) -> Bool {
    return module.dataStore.isFavoriteExercise(exercise)
  }
  
  @MainActor
  func localSearchByMuscleQuery(_ query: String) {
    state = .loading
    
    do {
      let exercises = try module.dataStore.fetchExercisesByMuscle(query)
      self.state = .loaded(exercises)
    } catch {
      self.state = .error(error.localizedDescription)
    }
  }
  
  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) {
    favoriteTask = Task { @MainActor [ weak self] in
      guard let self else { return }
      await self.module.dataStore.favoriteExercise(exercise, isFavorite: isFavorite)
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
