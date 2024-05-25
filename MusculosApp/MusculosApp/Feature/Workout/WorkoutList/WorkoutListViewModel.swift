//
//  WorkoutListViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.05.2024.
//

import Foundation
import SwiftUI

final class WorkoutListViewModel: ObservableObject {
  @Published var state: LoadingViewState<[Workout]> = .empty
  @Published var searchQuery: String = ""
  @Published var selectedWorkout: Workout? = nil {
    didSet {
      if selectedWorkout != nil {
        showWorkoutFlow = true
      }
    }
  }
  @Published var showWorkoutFlow: Bool = false
  
  private let dataStore: WorkoutDataStore
  
  private(set) var loadTask: Task<Void, Never>?
  
  init(dataStore: WorkoutDataStore = WorkoutDataStore()) {
    self.dataStore = dataStore
  }
  
  var isLoading: Bool {
    return state == .loading
  }
  
  func initialLoad() {
    loadTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      let workouts = await dataStore.getAll()
      
      if workouts.count > 0 {
        state = .loaded(workouts)
      } else {
        state = .error("No workouts found!")
      }
    }
  }
}
