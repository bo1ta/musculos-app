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
  
  init(exerciseModule: ExerciseModuleProtocol = ExerciseModule(dataImporter: DataImporter(context: CoreDataStack.shared.backgroundContext))) {
    self.exerciseModule = exerciseModule
  }
  
  @MainActor
  func loadExercises() async {
    do {
      let exercises = try await exerciseModule.getExercises()
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
