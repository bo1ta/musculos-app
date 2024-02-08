//
//  ExerciseStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.02.2024.
//

import Foundation
import SwiftUI

class ExerciseStore: ObservableObject {
  @Published var isLoading: Bool = false
  @Published var results: [Exercise] = []
  @Published var error: Error? = nil
  
  private let module: ExerciseModuleProtocol
  
  private(set) var loadExercisesTask: Task<Void, Never>?
  private(set) var filterExercisesTask: Task<Void, Never>?
  
  init(module: ExerciseModuleProtocol = ExerciseModule()) {
    self.module = module
  }
  
  func loadExercises() {
    loadExercisesTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        self.results = try await self.module.getExercises()
      } catch {
        self.error = error
      }
    }
  }
  
  func loadFilteredExercises(with filters: [String: [String]]) {
    filterExercisesTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { isLoading = false }
      
      do {
        self.results = try await self.module.getFilteredExercises(filters: filters)
      } catch {
        self.error = error
      }
    }
  }
  
  func cleanUp() {
    filterExercisesTask?.cancel()
    filterExercisesTask = nil
    
    loadExercisesTask?.cancel()
    loadExercisesTask = nil
  }
}
