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
  
  @Published var exerciseDetail: Exercise? = nil
  @Published var showExerciseDetail: Bool = false
  
  private let exerciseModule: ExerciseModuleProtocol
  
  private(set) var loadExercisesTask: Task<Void, Never>?
  private(set) var filterExercisesTask: Task<Void, Never>?
  private(set) var searchTask: Task<Void, Never>?
  
  init(exerciseModule: ExerciseModuleProtocol = ExerciseModule()) {
    self.exerciseModule = exerciseModule
  }
  
  func loadExercises() {
    loadExercisesTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        var exercises = try await self.exerciseModule.getExercises()
        self.results = exercises
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
      
//      do {
//        let exercises =  try await self.exerciseModule.getFilteredExercises(filters: filters)
//        self.results = exercises
//      } catch {
//        self.error = error
//      }
    }
  }
  
  func cleanExerciseImages() {
    self.exerciseDetail = nil
    self.showExerciseDetail = false
  }
  
  func searchFor(query: String) {
    searchTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
//      do {
//        let exercises = try await self.exerciseModule.searchFor(query: query)
//        self.results = exercises
//      } catch {
//        self.error = error
//      }
    }
  }
  
  func cleanUp() {
    filterExercisesTask?.cancel()
    filterExercisesTask = nil
    
    loadExercisesTask?.cancel()
    loadExercisesTask = nil
    
    searchTask?.cancel()
    searchTask = nil
  }
}
