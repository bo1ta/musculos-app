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
  
  @Published var exerciseWithAllImages: Exercise? = nil
  @Published var exerciseHasAllImages: Bool = false
  
  private let exerciseModule: ExerciseModuleProtocol
  private let exerciseImageModule: ExerciseImageModule
  
  private(set) var loadExercisesTask: Task<Void, Never>?
  private(set) var filterExercisesTask: Task<Void, Never>?
  private(set) var searchTask: Task<Void, Never>?
  private(set) var loadAllImagesTask: Task<Void, Never>?
  
  init(exerciseModule: ExerciseModuleProtocol = ExerciseModule(), exerciseImageModule: ExerciseImageModule = ExerciseImageModule()) {
    self.exerciseModule = exerciseModule
    self.exerciseImageModule = exerciseImageModule
  }
  
  func loadExercises() {
    loadExercisesTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        var exercises = try await self.exerciseModule.getExercises()
        self.results = try await loadInitialImage(for: exercises)
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
        var exercises =  try await self.exerciseModule.getFilteredExercises(filters: filters)
        self.results = try await loadInitialImage(for: exercises)
      } catch {
        self.error = error
      }
    }
  }
  
  func loadAllImagesForExercise(_ exercise: Exercise) {
    loadAllImagesTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { isLoading = false }
      
      do {
        let exerciseWithAllImages = try await exerciseImageModule.loadAllImages(for: exercise)
        self.exerciseHasAllImages = true
        self.exerciseWithAllImages = exerciseWithAllImages
      } catch {
        self.error = error
      }
    }
  }
  
  func cleanExerciseImages() {
    self.exerciseHasAllImages = false
    self.exerciseWithAllImages = nil
  }
  
  private func loadInitialImage(for exercises: [Exercise]) async throws -> [Exercise] {
    var newExercises = exercises
    return try await newExercises.asyncCompactMap { exercise in
      return try await self.exerciseImageModule.loadInitialImage(for: exercise)
    }
  }
  
  func searchFor(query: String) {
    searchTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        let exercises = try await self.exerciseModule.searchFor(query: query)
        self.results = exercises
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
    
    searchTask?.cancel()
    searchTask = nil
    
    loadAllImagesTask?.cancel()
    loadAllImagesTask = nil
  }
}
