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
    state = .loading
    
    do {
      let exercises = try exerciseDataStore.fetchExercises()
      state = .loaded(exercises)
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  func loadFilteredExercises(with filters: [String: [String]]) {
  }
  
  @MainActor
  func searchFor(query: String) {
  }
}
