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
  
  @MainActor
  func loadExercises() async {
    state = .loading
    
    do {
      let exercises = try await exerciseModule.getExercises()
      await exerciseDataStore.saveLocalChanges()
  
      state = .loaded(exercises)
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  func loadLocalExercises() {
    state = .loading
    
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
      
      self.state = .loading
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
