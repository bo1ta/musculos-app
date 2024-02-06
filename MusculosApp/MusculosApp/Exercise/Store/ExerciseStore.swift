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
  
  private(set) var task: Task<Void, Never>?

  init(module: ExerciseModuleProtocol = ExerciseModule()) {
    self.module = module
  }
  
  func loadExercises() {
    task = Task { @MainActor [weak self] in
      guard let self else { return }
      self.isLoading = true
      defer { self.isLoading = false }
      do {
        self.results = try await self.module.fetchWithImageUrl()
      } catch {
        self.error = error
      }
    }
  }
  
  func cleanUp() {
    task?.cancel()
    task = nil
  }
}
