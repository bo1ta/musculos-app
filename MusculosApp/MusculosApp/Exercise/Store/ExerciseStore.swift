//
//  ExerciseStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.02.2024.
//

import Foundation
import SwiftUI

class ExerciseStore: ObservableObject {
  @Published var state: LoadingViewState<[Exercise]> = .loading
  
  private let exerciseModule: ExerciseModuleProtocol
  private let exerciseDataStore: ExerciseDataStore
  
  init(exerciseModule: ExerciseModuleProtocol = ExerciseModule(), exerciseDataStore: ExerciseDataStore = ExerciseDataStore()) {
    self.exerciseModule = exerciseModule
    self.exerciseDataStore = exerciseDataStore
  }
  
  private(set) var searchTask: Task<Void, Never>?
  
  var discoverExercises: [[Exercise]] {
    if case let LoadingViewState.loaded(exercises) = state {
      return exercises.chunked(into: 5)
    }
    return [[]]
  }
  
  @MainActor
  func loadExercises() async {
    do {
      let exercises = try await exerciseModule.getExercises()
      await exerciseDataStore.saveLocalChanges()
  
      state = .loaded(exercises)
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  func loadLocalExercises() {
    do {
      let exercises = try exerciseDataStore.fetchExercises()
      state = .loaded(exercises)
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  func searchByMuscleQuery(_ query: String) {
    searchTask = Task { @MainActor [weak self] in
      guard let self else { return }
      do {
        let exercises = try await self.exerciseModule.searchByMuscleQuery(query)
        self.state = .loaded(exercises)
      } catch {
        self.state = .error(error.localizedDescription)
      }
    }
  }
  
  func cleanUp() {
    searchTask?.cancel()
    searchTask = nil
  }
  
  @MainActor
  func searchFor(query: String) {
  }
}
